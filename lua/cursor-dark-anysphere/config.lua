local M = {}

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
        oil = true,
    },
}

M.config = vim.deepcopy(M.default_config)

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    
    -- Validate configuration
    if M.config.transparency_mode ~= 'blended' 
        and M.config.transparency_mode ~= 'transparent' 
        and M.config.transparency_mode ~= 'opaque' then
        vim.notify(
            "Invalid transparency_mode: " .. M.config.transparency_mode .. 
            ". Using 'blended' instead.",
            vim.log.levels.WARN
        )
        M.config.transparency_mode = 'blended'
    end
    
    -- If transparent is true, override transparency_mode
    if M.config.transparent then
        M.config.transparency_mode = 'transparent'
    end
end

function M.get()
    return M.config
end

return M