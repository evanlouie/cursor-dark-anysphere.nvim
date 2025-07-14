local M = {}
local utils = require('cursor-dark-anysphere.utils')

-- Performance monitoring and caching
local theme_cache = {}
local last_config_hash = nil

-- Generate configuration hash for cache invalidation
local function generate_config_hash(config)
    local key_parts = {
        config.transparency_mode or "blended",
        tostring(config.transparent or false),
        config.style or "dark"
    }
    
    -- Add transparency settings
    if config.transparencies then
        for k, v in pairs(config.transparencies) do
            table.insert(key_parts, k .. ":" .. tostring(v))
        end
    end
    
    -- Add enabled plugins
    if config.plugins then
        for k, v in pairs(config.plugins) do
            if v then
                table.insert(key_parts, "plugin:" .. k)
            end
        end
    end
    
    table.sort(key_parts)
    return table.concat(key_parts, "|")
end

-- Clear theme cache when needed
local function clear_theme_cache()
    theme_cache = {}
    -- Clear other caches too
    if utils.clear_caches then
        utils.clear_caches()
    end
    local palette = require('cursor-dark-anysphere.palette')
    if palette.clear_cache then
        palette.clear_cache()
    end
    local plugins = require('cursor-dark-anysphere.groups.plugins')
    if plugins.clear_cache then
        plugins.clear_cache()
    end
end

local function load_highlights(groups)
    -- Clear existing highlights
    if vim.fn.exists('syntax_on') then
        vim.cmd('syntax reset')
    end
    
    -- Apply highlight groups
    for group, settings in pairs(groups) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

function M.setup(opts)
    -- Performance monitoring for theme setup
    local cfg, colors = utils.monitor_performance("theme_setup", function()
        -- Setup configuration
        local config = require('cursor-dark-anysphere.config')
        config.setup(opts)
        
        -- Get processed configuration
        local cfg = config.get()
        
        -- Generate configuration hash for caching
        local config_hash = generate_config_hash(cfg)
        
        -- Check if we can use cached theme
        if theme_cache[config_hash] and last_config_hash == config_hash then
            -- Apply cached highlights
            load_highlights(theme_cache[config_hash])
            return cfg, nil -- Return nil for colors since we used cache
        end
        
        -- Clear cache if configuration changed significantly
        if last_config_hash and last_config_hash ~= config_hash then
            clear_theme_cache()
        end
        
        last_config_hash = config_hash
        
        -- Get palette based on transparency mode (with caching)
        local palette = require('cursor-dark-anysphere.palette')
        local colors = palette.get_colors(cfg.transparency_mode)
        
        -- Override colors if provided
        if cfg.colors then
            local success, result = pcall(function()
                return utils.safe_tbl_deep_extend("force", colors, cfg.colors)
            end)
            
            if success and result then
                colors = result
            else
                -- Fallback: basic color override
                for k, v in pairs(cfg.colors) do
                    colors[k] = v
                end
            end
        end
        
        -- Set vim options
        vim.g.colors_name = 'cursor-dark-anysphere'
        vim.o.termguicolors = true
        vim.o.background = 'dark'
        
        -- Load highlight groups with performance monitoring
        local groups = utils.monitor_performance("highlight_generation", function()
            local result = {}
            
            -- Helper function to safely merge highlight groups
            local function safe_merge_groups(base, new_groups)
                local success, merged = pcall(function()
                    return utils.safe_tbl_deep_extend("force", base, new_groups)
                end)
                
                if success and merged then
                    return merged
                else
                    -- Fallback: basic merging
                    for k, v in pairs(new_groups) do
                        base[k] = v
                    end
                    return base
                end
            end
            
            -- Editor highlights
            local editor = require('cursor-dark-anysphere.groups.editor')
            result = safe_merge_groups(result, editor.setup(colors, cfg))
            
            -- Syntax highlights
            local syntax = require('cursor-dark-anysphere.groups.syntax')
            result = safe_merge_groups(result, syntax.setup(colors, cfg))
            
            -- Treesitter highlights (conditional loading)
            if cfg.plugins.treesitter then
                local treesitter = require('cursor-dark-anysphere.groups.treesitter')
                result = safe_merge_groups(result, treesitter.setup(colors, cfg))
            end
            
            -- Plugin highlights (with lazy loading)
            local plugins = require('cursor-dark-anysphere.groups.plugins')
            result = safe_merge_groups(result, plugins.setup(colors, cfg))
            
            -- Override highlights if provided
            if cfg.highlights then
                result = safe_merge_groups(result, cfg.highlights)
            end
            
            return result
        end)
        
        -- Use optimized highlight processing if available
        if utils.process_highlight_groups_batched then
            groups = utils.process_highlight_groups_batched(groups, 50)
        end
        
        -- Cache the theme for future use
        theme_cache[config_hash] = groups
        
        -- Apply all highlights
        load_highlights(groups)
        
        return cfg, colors
    end)
    
    -- Handle post-setup operations only if we have fresh colors
    if colors then
        -- Ensure snacks.nvim highlights apply after plugin loads
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyDone",
            callback = function()
                if cfg.plugins.snacks then
                    local snacks_groups = {
                        SnacksPickerFile = { fg = colors.sidebar_fg },
                        SnacksPickerDir = { fg = colors.blue2, bold = true },
                        SnacksExplorerFile = { fg = colors.sidebar_fg },
                        SnacksExplorerDir = { fg = colors.blue2, bold = true },
                        SnacksExplorerNormal = { fg = colors.sidebar_fg, bg = cfg.transparencies.sidebar and "NONE" or colors.ui_bg },
                    }
                    
                    for group, settings in pairs(snacks_groups) do
                        vim.api.nvim_set_hl(0, group, settings)
                    end
                end
            end,
        })
        
        -- Set terminal colors
        if vim.o.termguicolors then
            vim.g.terminal_color_0 = colors.gray1
            vim.g.terminal_color_1 = colors.red1
            vim.g.terminal_color_2 = colors.green1
            vim.g.terminal_color_3 = colors.yellow1
            vim.g.terminal_color_4 = colors.blue1
            vim.g.terminal_color_5 = colors.purple1
            vim.g.terminal_color_6 = colors.blue2
            vim.g.terminal_color_7 = colors.white
            vim.g.terminal_color_8 = colors.gray3
            vim.g.terminal_color_9 = colors.red1
            vim.g.terminal_color_10 = colors.green1
            vim.g.terminal_color_11 = colors.yellow1
            vim.g.terminal_color_12 = colors.blue1
            vim.g.terminal_color_13 = colors.purple1
            vim.g.terminal_color_14 = colors.blue2
            vim.g.terminal_color_15 = colors.white
            
            -- Background and foreground
            vim.g.terminal_color_background = colors.ui_bg
            vim.g.terminal_color_foreground = colors.terminal_fg
        end
    end
end

-- Lualine theme support
function M.get_lualine_theme()
    local config = require('cursor-dark-anysphere.config').get()
    local palette = require('cursor-dark-anysphere.palette')
    local c = palette.get_colors(config.transparency_mode)
    
    local theme = {
        normal = {
            a = { fg = c.black, bg = c.blue2, gui = 'bold' },
            b = { fg = c.editor_fg, bg = c.gray1 },
            c = { fg = c.statusbar_fg, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
        insert = {
            a = { fg = c.black, bg = c.green1, gui = 'bold' },
            b = { fg = c.editor_fg, bg = c.gray1 },
            c = { fg = c.statusbar_fg, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
        visual = {
            a = { fg = c.black, bg = c.purple2, gui = 'bold' },
            b = { fg = c.editor_fg, bg = c.gray1 },
            c = { fg = c.statusbar_fg, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
        replace = {
            a = { fg = c.black, bg = c.red1, gui = 'bold' },
            b = { fg = c.editor_fg, bg = c.gray1 },
            c = { fg = c.statusbar_fg, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
        command = {
            a = { fg = c.black, bg = c.yellow2, gui = 'bold' },
            b = { fg = c.editor_fg, bg = c.gray1 },
            c = { fg = c.statusbar_fg, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
        inactive = {
            a = { fg = c.gray7, bg = c.gray1 },
            b = { fg = c.gray7, bg = c.ui_bg },
            c = { fg = c.gray7, bg = config.transparencies.statusline and 'NONE' or c.ui_bg },
        },
    }
    
    return theme
end

-- Get colors for external use
function M.get_colors()
    local config = require('cursor-dark-anysphere.config').get()
    local palette = require('cursor-dark-anysphere.palette')
    return palette.get_colors(config.transparency_mode)
end

return M
