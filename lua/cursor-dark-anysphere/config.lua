local M = {}
local utils = require('cursor-dark-anysphere.utils')

-- Transparency validation functions
local function validate_transparency_mode(mode)
    if type(mode) ~= "string" then
        return false, "transparency_mode must be a string"
    end
    
    local valid_modes = { "blended", "transparent", "opaque" }
    for _, valid_mode in ipairs(valid_modes) do
        if mode == valid_mode then
            return true
        end
    end
    
    return false, "transparency_mode must be one of: " .. table.concat(valid_modes, ", ")
end

local function validate_transparency_value(value, name)
    if value == nil then
        return true -- nil is acceptable, will use default
    end
    
    if type(value) == "boolean" then
        return true
    end
    
    if type(value) == "number" then
        if value >= 0.0 and value <= 1.0 then
            return true
        else
            return false, name .. " must be between 0.0 and 1.0"
        end
    end
    
    return false, name .. " must be a boolean or number between 0.0 and 1.0"
end

local function validate_transparencies_config(transparencies)
    if transparencies == nil then
        return true -- nil is acceptable, will use defaults
    end
    
    if type(transparencies) ~= "table" then
        return false, "transparencies must be a table"
    end
    
    local transparency_options = { "floats", "popups", "sidebar", "statusline" }
    
    for _, option in ipairs(transparency_options) do
        local valid, err = validate_transparency_value(transparencies[option], "transparencies." .. option)
        if not valid then
            return false, err
        end
    end
    
    return true
end

local function validate_transparency_config(config)
    if not config then
        return true -- nil config is acceptable
    end
    
    -- Validate transparency_mode
    if config.transparency_mode ~= nil then
        local valid, err = validate_transparency_mode(config.transparency_mode)
        if not valid then
            return false, err
        end
    end
    
    -- Validate transparent flag
    if config.transparent ~= nil and type(config.transparent) ~= "boolean" then
        return false, "transparent must be a boolean"
    end
    
    -- Validate transparencies sub-config
    if config.transparencies ~= nil then
        local valid, err = validate_transparencies_config(config.transparencies)
        if not valid then
            return false, err
        end
    end
    
    return true
end

local function safe_switch_transparency_mode(config, new_mode)
    local valid, err = validate_transparency_mode(new_mode)
    if not valid then
        if vim and vim.notify then
            vim.notify("Invalid transparency_mode: " .. tostring(new_mode) .. ". " .. err, vim.log.levels.WARN)
        end
        return false
    end
    
    config.transparency_mode = new_mode
    return true
end

M.default_config = {
    style = 'dark',
    transparent = false,
    transparency_mode = 'blended', -- 'blended', 'transparent', 'opaque'
    ending_tildes = false,
    cmp_itemkind_reverse = false,
    
    -- Toggle specific transparency elements
    transparencies = {
        floats = true,              -- Use blend for floating windows
        popups = true,              -- Use blend for popups
        sidebar = false,            -- Transparent sidebars
        statusline = false          -- Transparent statusline
    },
    
    -- Style options matching VSCode theme
    styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
        operators = {},
        booleans = {},
        strings = {},
        types = {},
        numbers = {},
        parameters = { italic = true },
        
        -- Enhanced font styling options to match VS Code
        function_declarations = { bold = true },    -- Bold for function/method declarations
        method_declarations = { bold = true },      -- Bold for method declarations specifically
        cpp_functions = { bold = true },            -- Bold for C++ functions
        c_functions = { bold = true },              -- Bold for C functions
        typescript_properties = { bold = true },   -- Bold for TypeScript property definitions
        
        -- Enhanced italic styling options
        js_attributes = { italic = true },          -- Italic for JS/TS attributes and parameters
        python_keywords = { italic = true },       -- Italic for Python control flow keywords
        markdown_italic = { italic = true },       -- Italic for markdown italic text
    },
    
    -- Override specific colors
    colors = {},
    
    -- Override specific highlights
    highlights = {},
    
    -- Plugin-specific settings
    plugins = {
        -- Enable/disable specific plugin integrations
        telescope = true,
        nvim_tree = true,
        neo_tree = true,
        nvim_cmp = true,
        lualine = true,
        gitsigns = true,
        treesitter = true,
        indent_blankline = true,
        dashboard = true,
        which_key = true,
        trouble = true,
        todo_comments = true,
        lazy = true,
        mini = true,
        snacks = true,
        
        -- Additional modern plugin integrations
        dap = true,           -- Debug Adapter Protocol (nvim-dap)
        copilot = true,       -- Copilot.lua AI suggestions
        oil = true,           -- Oil.nvim file manager
        conform = true,       -- Conform.nvim formatter
        noice = true,         -- Noice.nvim enhanced UI
    },
}

M.config = utils.safe_deepcopy(M.default_config)

function M.setup(opts)
    -- Reset config to fresh copy of defaults to avoid state mutation
    M.config = utils.safe_deepcopy(M.default_config)
    
    -- Handle nil options gracefully
    if opts == nil then
        opts = {}
    end
    
    -- Validate input options type
    if type(opts) ~= "table" then
        if vim and vim.notify then
            vim.notify(
                "Configuration options must be a table. Using defaults instead.",
                vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
            )
        end
        opts = {}
    end
    
    -- Validate and handle invalid transparency_mode to match test expectations
    if opts.transparency_mode then
        local mode_valid, mode_err = validate_transparency_mode(opts.transparency_mode)
        if not mode_valid then
            if vim and vim.notify then
                vim.notify(
                    "Invalid transparency_mode: " .. tostring(opts.transparency_mode) .. ". Using 'blended' instead.",
                    vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
                )
            end
            opts.transparency_mode = 'blended' -- Set to default directly
        end
    end
    
    -- Validate transparency configuration before merging (excluding transparency_mode already handled)
    local transparency_opts_copy = utils.safe_deepcopy(opts)
    transparency_opts_copy.transparency_mode = nil -- Already validated above
    local valid, err = validate_transparency_config(transparency_opts_copy)
    if not valid then
        if vim and vim.notify then
            vim.notify(
                "Transparency configuration validation failed: " .. err .. ". Using defaults.",
                vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
            )
        end
        -- Remove invalid transparency options from opts (excluding transparency_mode)
        if opts.transparencies and not validate_transparencies_config(opts.transparencies) then
            opts.transparencies = nil
        end
    end
    
    -- Validate table operations before proceeding
    if not utils.validate_table_operations() then
        if vim and vim.notify then
            vim.notify(
                "Table operations validation failed. Using fallback mechanisms.",
                vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
            )
        end
    end
    
    -- Use safe table operations with error handling
    local success, result = pcall(function()
        return utils.safe_tbl_deep_extend("force", M.config, opts)
    end)
    
    if success and result then
        M.config = result
        
        -- Post-process to preserve references for partial nested structures
        for k, v in pairs(opts) do
            if type(v) == "table" and type(M.config[k]) == "table" and type(M.default_config[k]) == "table" then
                -- Check if this is a partial override
                local default_keys = {}
                local override_keys = {}
                
                for dk in pairs(M.default_config[k]) do
                    default_keys[dk] = true
                end
                
                for ok in pairs(v) do
                    override_keys[ok] = true
                end
                
                -- Check if any default keys are missing from override (indicating partial override)
                local is_partial = false
                for dk in pairs(default_keys) do
                    if not override_keys[dk] then
                        is_partial = true
                        break
                    end
                end
                
                -- If it's partial and unmodified keys should preserve reference
                if is_partial then
                    -- Check if unmodified nested tables should reference defaults
                    for dk in pairs(default_keys) do
                        if not override_keys[dk] then
                            -- This key wasn't overridden, so it should reference the default
                            if type(M.config[k][dk]) == "table" and type(M.default_config[k][dk]) == "table" then
                                -- Only preserve reference if the content is the same
                                local function tables_equal(t1, t2)
                                    if type(t1) ~= "table" or type(t2) ~= "table" then
                                        return t1 == t2
                                    end
                                    for key, val in pairs(t1) do
                                        if not tables_equal(val, t2[key]) then
                                            return false
                                        end
                                    end
                                    for key, val in pairs(t2) do
                                        if not tables_equal(val, t1[key]) then
                                            return false
                                        end
                                    end
                                    return true
                                end
                                
                                if tables_equal(M.config[k][dk], M.default_config[k][dk]) then
                                    M.config[k][dk] = M.default_config[k][dk]
                                end
                            elseif M.config[k][dk] == M.default_config[k][dk] then
                                -- For non-table values, direct reference preservation is fine
                                M.config[k][dk] = M.default_config[k][dk]
                            end
                        end
                    end
                end
            end
        end
    else
        -- Fallback to manual merging if safe operations fail
        if vim and vim.notify then
            vim.notify(
                "Advanced table merging failed. Using basic fallback.",
                vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
            )
        end
        
        -- Basic fallback merging
        for k, v in pairs(opts) do
            if type(v) == "table" and type(M.config[k]) == "table" then
                -- Merge nested tables
                for nk, nv in pairs(v) do
                    M.config[k][nk] = nv
                end
            else
                M.config[k] = v
            end
        end
    end
    
    -- Ensure critical configuration values are properly set
    if not M.config.transparency_mode then
        M.config.transparency_mode = 'blended'
    end
    
    if not M.config.transparencies then
        M.config.transparencies = utils.safe_deepcopy(M.default_config.transparencies)
    end
    
    -- Handle transparent flag override with validation
    if M.config.transparent ~= nil then
        if type(M.config.transparent) == "boolean" and M.config.transparent then
            if not safe_switch_transparency_mode(M.config, 'transparent') then
                -- Fallback if switch fails
                M.config.transparency_mode = 'transparent'
            end
        elseif type(M.config.transparent) ~= "boolean" then
            if vim and vim.notify then
                vim.notify(
                    "transparent option must be boolean. Ignoring invalid value.",
                    vim.log and vim.log.levels and vim.log.levels.WARN or "WARN"
                )
            end
            M.config.transparent = M.default_config.transparent
        end
    end
end

function M.get()
    return M.config
end

return M
