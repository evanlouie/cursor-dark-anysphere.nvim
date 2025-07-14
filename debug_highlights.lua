-- Debug utility to check which highlight groups are active in the file explorer
-- Usage: :lua require('debug_highlights').check_file_explorer_highlights()

local M = {}

function M.check_file_explorer_highlights()
    -- Get the current buffer's filetype and window info
    local current_buf = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()
    local filetype = vim.api.nvim_buf_get_option(current_buf, 'filetype')
    
    print("=== File Explorer Highlight Debug ===")
    print("Buffer: " .. current_buf)
    print("Window: " .. current_win)
    print("Filetype: " .. filetype)
    print("")
    
    -- Check nvim-tree specific highlights
    local nvim_tree_groups = {
        "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeFileName", "NvimTreeFileIcon",
        "NvimTreeFolderName", "NvimTreeFolderIcon", "NvimTreeText", "NvimTreeFile",
        "NvimTreeCursorLine", "NvimTreeEndOfBuffer"
    }
    
    print("=== NvimTree Highlight Groups ===")
    for _, group in ipairs(nvim_tree_groups) do
        local hl = vim.api.nvim_get_hl_by_name(group, true)
        if next(hl) then
            local fg = hl.foreground and string.format("#%06x", hl.foreground) or "none"
            local bg = hl.background and string.format("#%06x", hl.background) or "none"
            print(string.format("%s: fg=%s, bg=%s", group, fg, bg))
        else
            print(group .. ": not defined")
        end
    end
    
    print("")
    print("=== Generic Highlight Groups ===")
    local generic_groups = {"Normal", "Directory", "Comment", "Identifier", "Special"}
    for _, group in ipairs(generic_groups) do
        local hl = vim.api.nvim_get_hl_by_name(group, true)
        local fg = hl.foreground and string.format("#%06x", hl.foreground) or "none"
        local bg = hl.background and string.format("#%06x", hl.background) or "none"
        print(string.format("%s: fg=%s, bg=%s", group, fg, bg))
    end
    
    print("")
    print("=== Theme Colors ===")
    local theme = require('cursor-dark-anysphere')
    local colors = theme.get_colors()
    print("sidebar_fg: " .. (colors.sidebar_fg or "not defined"))
    print("editor_fg: " .. (colors.editor_fg or "not defined"))
    print("ui_bg: " .. (colors.ui_bg or "not defined"))
end

function M.inspect_cursor_highlight()
    -- Get highlight group under cursor
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')
    local synID = vim.fn.synID(line, col, 1)
    local synName = vim.fn.synIDattr(synID, "name")
    local transName = vim.fn.synIDattr(vim.fn.synIDtrans(synID), "name")
    
    print("=== Cursor Position Highlight ===")
    print("Position: line " .. line .. ", col " .. col)
    print("Syntax group: " .. synName)
    print("Translated to: " .. transName)
    
    if synName ~= "" then
        local hl = vim.api.nvim_get_hl_by_name(synName, true)
        local fg = hl.foreground and string.format("#%06x", hl.foreground) or "none"
        local bg = hl.background and string.format("#%06x", hl.background) or "none"
        print(string.format("Colors: fg=%s, bg=%s", fg, bg))
    end
end

function M.fix_nvim_tree_colors()
    -- Force reapply nvim-tree highlights with correct colors
    local theme = require('cursor-dark-anysphere')
    local colors = theme.get_colors()
    
    print("=== Applying NvimTree Color Fix ===")
    print("Using sidebar_fg: " .. colors.sidebar_fg)
    
    -- Force set key highlight groups
    local highlights = {
        NvimTreeNormal = { fg = colors.sidebar_fg },
        NvimTreeFileName = { fg = colors.sidebar_fg },
        NvimTreeFileIcon = { fg = colors.sidebar_fg },
        NvimTreeFolderName = { fg = colors.sidebar_fg },
        NvimTreeText = { fg = colors.sidebar_fg },
        NvimTreeFile = { fg = colors.sidebar_fg },
    }
    
    for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
        print("Set " .. group .. " to fg=" .. settings.fg)
    end
    
    print("Highlight fix applied. Try refreshing your file explorer.")
end

return M