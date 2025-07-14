local M = {}

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
    -- Setup configuration
    local config = require('cursor-dark-anysphere.config')
    config.setup(opts)
    
    -- Get processed configuration
    local cfg = config.get()
    
    -- Get palette based on transparency mode
    local palette = require('cursor-dark-anysphere.palette')
    local colors = palette.get_colors(cfg.transparency_mode)
    
    -- Override colors if provided
    if cfg.colors then
        colors = vim.tbl_deep_extend("force", colors, cfg.colors)
    end
    
    -- Set vim options
    vim.g.colors_name = 'cursor-dark-anysphere'
    vim.o.termguicolors = true
    vim.o.background = 'dark'
    
    -- Load highlight groups
    local groups = {}
    
    -- Editor highlights
    local editor = require('cursor-dark-anysphere.groups.editor')
    groups = vim.tbl_deep_extend("force", groups, editor.setup(colors, cfg))
    
    -- Syntax highlights
    local syntax = require('cursor-dark-anysphere.groups.syntax')
    groups = vim.tbl_deep_extend("force", groups, syntax.setup(colors, cfg))
    
    -- Treesitter highlights
    if cfg.plugins.treesitter then
        local treesitter = require('cursor-dark-anysphere.groups.treesitter')
        groups = vim.tbl_deep_extend("force", groups, treesitter.setup(colors, cfg))
    end
    
    -- Plugin highlights
    local plugins = require('cursor-dark-anysphere.groups.plugins')
    groups = vim.tbl_deep_extend("force", groups, plugins.setup(colors, cfg))
    
    -- Override highlights if provided
    if cfg.highlights then
        groups = vim.tbl_deep_extend("force", groups, cfg.highlights)
    end
    
    -- Apply all highlights
    load_highlights(groups)
    
    -- Set up autocommand to reapply file explorer highlights after plugin loads
    -- This ensures our theme highlights take precedence over plugin defaults
    vim.api.nvim_create_autocmd("FileType", {
        pattern = {"NvimTree", "neo-tree", "oil", "snacks_explorer"},
        callback = function()
            -- Reapply file explorer specific highlights
            local file_explorer_groups = {}
            if cfg.plugins.nvim_tree then
                file_explorer_groups.NvimTreeNormal = { fg = colors.sidebar_fg, bg = cfg.transparencies.sidebar and "NONE" or colors.ui_bg }
                file_explorer_groups.NvimTreeFileName = { fg = colors.sidebar_fg }
                file_explorer_groups.NvimTreeFileIcon = { fg = colors.sidebar_fg }
                file_explorer_groups.NvimTreeFolderName = { fg = colors.sidebar_fg }
                file_explorer_groups.NvimTreeText = { fg = colors.sidebar_fg }
                file_explorer_groups.NvimTreeFile = { fg = colors.sidebar_fg }
            end
            if cfg.plugins.neo_tree then
                file_explorer_groups.NeoTreeNormal = { fg = colors.sidebar_fg, bg = cfg.transparencies.sidebar and "NONE" or colors.ui_bg }
                file_explorer_groups.NeoTreeFileName = { fg = colors.sidebar_fg }
                file_explorer_groups.NeoTreeDirectoryName = { fg = colors.sidebar_fg }
            end
            if cfg.plugins.oil then
                file_explorer_groups.OilFile = { fg = colors.sidebar_fg }
                file_explorer_groups.OilDir = { fg = colors.blue2 }
            end
            if cfg.plugins.snacks then
                file_explorer_groups.SnacksPickerFile = { fg = colors.sidebar_fg }
                file_explorer_groups.SnacksPickerDir = { fg = colors.blue2, bold = true }
                file_explorer_groups.SnacksExplorerFile = { fg = colors.sidebar_fg }
                file_explorer_groups.SnacksExplorerDir = { fg = colors.blue2, bold = true }
                file_explorer_groups.SnacksExplorerNormal = { fg = colors.sidebar_fg, bg = cfg.transparencies.sidebar and "NONE" or colors.ui_bg }
            end
            
            for group, settings in pairs(file_explorer_groups) do
                vim.api.nvim_set_hl(0, group, settings)
            end
        end,
    })
    
    -- Additional autocommand for snacks picker highlights
    -- Snacks often loads after other plugins, so we need this extra trigger
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
            if cfg.plugins.snacks then
                local snacks_groups = {
                    SnacksPickerFile = { fg = colors.sidebar_fg },
                    SnacksPickerDir = { fg = colors.blue2, bold = true },
                    SnacksPickerPathHidden = { fg = colors.gray4 },
                    SnacksPickerPathIgnored = { fg = colors.gray3 },
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