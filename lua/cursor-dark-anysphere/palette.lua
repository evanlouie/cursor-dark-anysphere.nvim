local utils = require('cursor-dark-anysphere.utils')

local M = {}

-- Palette cache for different transparency modes
local palette_cache = {}
local cache_generation = 0

-- Cache invalidation when transparency mode changes
local last_transparency_mode = nil

-- Clear palette cache when needed
local function clear_palette_cache()
    palette_cache = {}
    cache_generation = cache_generation + 1
end

-- Performance monitoring for palette generation
local function monitor_palette_generation(mode, generation_func)
    return utils.monitor_performance("palette_generation_" .. mode, generation_func)
end

-- Raw colors from VSCode theme
M.vscode_colors = {
    -- Backgrounds
    editor_bg = "#1a1a1a",
    ui_bg = "#141414",
    minimap_bg = "#181818",
    
    -- Foregrounds
    editor_fg = "#D8DEE9",
    ui_fg = "#CCCCCCdd",
    ui_fg_dim = "#CCCCCC99",
    comment = "#FFFFFF5C",
    
    -- Base colors
    white = "#FFFFFF",
    black = "#000000",
    gray1 = "#2A2A2A",
    gray2 = "#404040",
    gray3 = "#505050",
    gray4 = "#606060",
    gray5 = "#767676",
    gray6 = "#898989",
    gray7 = "#CCCCCC",
    gray8 = "#D8DEE9",
    
    -- Accent colors
    blue1 = "#81A1C1",
    blue2 = "#88C0D0", 
    blue3 = "#87c3ff",
    blue4 = "#82d2ce",
    blue5 = "#94C1FA",
    
    green1 = "#A3BE8C",
    green2 = "#a8cc7c",
    green3 = "#15ac91",
    
    yellow1 = "#EBCB8B",
    yellow2 = "#efb080",
    yellow3 = "#ebc88d",
    yellow4 = "#f8c762",
    yellow5 = "#fad075",
    yellow6 = "#e5b95c",
    yellow7 = "#ea7620",
    
    red1 = "#BF616A",
    red2 = "#f14c4c",
    red3 = "#f44747",
    red4 = "#cc7c8a",
    red5 = "#C1808A",
    
    purple1 = "#B48EAD",
    purple2 = "#aaa0fa",
    purple3 = "#AA9BF5",
    purple4 = "#af9cff",
    
    pink = "#e394dc",
    
    -- Special values
    transparent = "#00000000",
    
    -- Alpha colors (to be processed)
    activity_fg = "#CCCCCC99",
    diff_added_bg = "#A3BE8C22",
    diff_removed_bg = "#BF616A22",
    find_match_bg = "#88C0D066",
    find_match_highlight_bg = "#88C0D044",
    find_range_highlight_bg = "#FFFFFF33",
    inactive_selection_bg = "#40404077",
    selection_bg = "#40404099",
    selection_highlight_bg = "#404040CC",
    snippet_highlight_bg = "#CCCCCC55",
    word_highlight_bg = "#ffffff21",
    word_highlight_strong_bg = "#ffffff2d",
    bracket_match_bg = "#14141400",
    bracket_match_border = "#FFFFFF55",
    group_border = "#ffffff0d",
    group_drop_bg = "#2A2A2A99",
    tabs_border = "#FFFFFF0D",
    editorInlayHint_bg = "#00000000",
    editorOverviewRuler_added = "#A3BE8C99",
    editorOverviewRuler_deleted = "#BF616A99",
    editorOverviewRuler_modified = "#EBCB8B99",
    editorOverviewRuler_border = "#00000000",
    editorWarning_border = "#CCCCCC00",
    editorError_border = "#BF616A00",
    editorWhitespace_fg = "#505050",
    editorIndentGuide_bg = "#404040",
    input_bg = "#2A2A2A55",
    input_placeholder_fg = "#FFFFFF99",
    list_active_selection_bg = "#ffffff1d",
    list_inactive_selection_bg = "#ffffff10",
    list_inactive_selection_fg = "#ffffffd7",
    list_drop_bg = "#FFFFFF99",
    list_hover_bg = "#2A2A2A99",
    menubar_selection_bg = "#CCCCCC33",
    merge_border = "#2A2A2A00",
    merge_current_content_bg = "#88C0D04D",
    merge_current_header_bg = "#88C0D066",
    merge_incoming_content_bg = "#A3BE8C4D",
    merge_incoming_header_bg = "#A3BE8C66",
    panel_border = "#FFFFFF0D",
    panel_title_active_border = "#FFFFFF00",
    panel_title_inactive_fg = "#CCCCCC99",
    peek_match_highlight_bg = "#FFFFFF66",
    peek_result_line_fg = "#FFFFFF66",
    scrollbar_shadow = "#00000000",
    scrollbar_slider_active_bg = "#60606055",
    scrollbar_slider_bg = "#40404055",
    scrollbar_slider_hover_bg = "#40404055",
    selection_bg_global = "#FFFFFF33",
    sidebar_border = "#FFFFFF0D",
    sidebar_fg = "#E5E5E5",
    statusbar_fg = "#cccccc82",
    statusbar_border = "#FFFFFF0D",
    tab_active_border_top = "#FFFFFF00",
    tab_border = "#FFFFFF0D",
    tab_hover_bg = "#FFFFFF00",
    tab_unfocused_active_border = "#88C0D000",
    tab_unfocused_active_fg = "#FFFFFF99",
    tab_unfocused_hover_bg = "#2A2A2AB3",
    tab_unfocused_hover_border = "#88C0D000",
    tab_unfocused_inactive_fg = "#FFFFFF66",
    terminal_fg = "#FFFFFFcc",
    terminal_selection_bg = "#636262dd",
    terminal_cursor_bg = "#FFFFFF22",
    titlebar_fg = "#cccccc82",
    titlebar_border = "#FFFFFF0D",
    titlebar_inactive_fg = "#cccccc60",
    tree_indent_guides = "#CCCCCC55",
    widget_shadow = "#00000066",
    minimap_find_match = "#15ac9170",
    marker_navigation_bg = "#ffffff70",
    marker_navigation_error_bg = "#BF616AC0",
    picker_group_border = "#2A2A2A00",
    
    -- Minimap colors
    minimap_gutter_added_bg = "#15ac91",
    minimap_gutter_modified_bg = "#e5b95c",
    minimap_gutter_deleted_bg = "#f14c4c",
    minimap_selection_highlight = "#363636",
    minimap_error_highlight = "#f14c4c",
    minimap_warning_highlight = "#ea7620",
    
    -- Button variants
    button_secondary_bg = "#565656",
    button_secondary_fg = "#ececec",
    button_secondary_hover_bg = "#767676",
    
    -- Input validation colors
    input_validation_error_fg = "#141414",
    input_validation_warning_fg = "#141414",
    
    -- Extension button colors
    extension_button_prominent_bg = "#565656",
    extension_button_prominent_fg = "#FFFFFF",
    extension_button_prominent_hover_bg = "#767676",
}

-- Get processed colors based on transparency mode with caching
---@param mode string 'blended', 'transparent', or 'opaque'
---@return table colors Processed color palette
function M.get_colors(mode)
    mode = mode or "blended"
    
    -- Check cache first
    if palette_cache[mode] and last_transparency_mode == mode then
        return palette_cache[mode]
    end
    
    -- Clear cache if transparency mode changed
    if last_transparency_mode and last_transparency_mode ~= mode then
        clear_palette_cache()
        -- Clear utils caches too for consistency
        if utils.clear_caches then
            utils.clear_caches()
        end
    end
    
    last_transparency_mode = mode
    
    -- Generate palette with performance monitoring
    local c = monitor_palette_generation(mode, function()
        local result = {}
        
        -- Copy non-alpha colors directly (optimized)
        for k, v in pairs(M.vscode_colors) do
            result[k] = v
        end
        
        -- Process alpha colors based on mode using bulk processing
        local bg = M.vscode_colors.editor_bg
        local ui_bg = M.vscode_colors.ui_bg
        
        -- Group alpha colors by background for bulk processing
        local bg_colors = {}
        local ui_bg_colors = {}
        
        -- Alpha colors that use editor_bg
        local editor_bg_keys = {
            "comment", "diff_added_bg", "diff_removed_bg", "find_match_bg",
            "find_match_highlight_bg", "find_range_highlight_bg", "selection_bg",
            "selection_highlight_bg", "inactive_selection_bg", "word_highlight_bg",
            "word_highlight_strong_bg", "snippet_highlight_bg", "bracket_match_border",
            "group_border", "editorIndentGuide_bg", "editorWhitespace_fg",
            "scrollbar_slider_bg", "scrollbar_slider_hover_bg", "scrollbar_slider_active_bg",
            "merge_current_content_bg", "merge_current_header_bg", "merge_incoming_content_bg",
            "merge_incoming_header_bg", "group_drop_bg", "editorOverviewRuler_added",
            "editorOverviewRuler_deleted", "editorOverviewRuler_modified"
        }
        
        -- Alpha colors that use ui_bg
        local ui_bg_keys = {
            "ui_fg_dim", "activity_fg", "list_active_selection_bg", "list_inactive_selection_bg",
            "list_hover_bg", "menubar_selection_bg", "input_bg", "input_placeholder_fg",
            "terminal_fg", "terminal_selection_bg", "terminal_cursor_bg", "statusbar_fg",
            "titlebar_fg", "titlebar_inactive_fg", "panel_title_inactive_fg", "sidebar_fg",
            "tree_indent_guides", "widget_shadow", "peek_match_highlight_bg", "peek_result_line_fg",
            "marker_navigation_bg", "marker_navigation_error_bg", "tab_unfocused_active_fg",
            "tab_unfocused_hover_bg", "tab_unfocused_inactive_fg", "list_drop_bg",
            "panel_border", "sidebar_border", "statusbar_border", "tab_border", "titlebar_border",
            "tabs_border"
        }
        
        -- Process colors in groups for better cache efficiency
        for _, key in ipairs(editor_bg_keys) do
            if M.vscode_colors[key] then
                bg_colors[key] = M.vscode_colors[key]
            end
        end
        
        for _, key in ipairs(ui_bg_keys) do
            if M.vscode_colors[key] then
                ui_bg_colors[key] = M.vscode_colors[key]
            end
        end
        
        -- Bulk process colors with same background
        local processed_bg = utils.process_colors_bulk and utils.process_colors_bulk(bg_colors, bg, mode) or {}
        local processed_ui_bg = utils.process_colors_bulk and utils.process_colors_bulk(ui_bg_colors, ui_bg, mode) or {}
        
        -- Merge processed colors back
        for k, v in pairs(processed_bg) do
            result[k] = v
        end
        for k, v in pairs(processed_ui_bg) do
            result[k] = v
        end
        
        -- Handle special cases that weren't in bulk processing
        result.minimap_find_match = utils.process_color(M.vscode_colors.minimap_find_match, M.vscode_colors.minimap_bg, mode)
        
        return result
    end)
    
    -- Use optimized palette processing if available
    if utils.optimize_color_palette then
        c = utils.optimize_color_palette(c, mode)
    end
    
    -- Cache the result
    palette_cache[mode] = c
    
    return c
end

-- Legacy get_colors function for compatibility (fallback if bulk processing fails)
local function get_colors_legacy(mode)
    mode = mode or "blended"
    local c = {}
    
    -- Copy non-alpha colors directly
    for k, v in pairs(M.vscode_colors) do
        c[k] = v
    end
    
    -- Process alpha colors based on mode
    local bg = M.vscode_colors.editor_bg
    local ui_bg = M.vscode_colors.ui_bg
    
    -- Comments and UI text with alpha
    c.comment = utils.process_color(M.vscode_colors.comment, bg, mode)
    c.ui_fg_dim = utils.process_color(M.vscode_colors.ui_fg_dim, ui_bg, mode)
    c.activity_fg = utils.process_color(M.vscode_colors.activity_fg, ui_bg, mode)
    
    -- Diff backgrounds
    c.diff_added_bg = utils.process_color(M.vscode_colors.diff_added_bg, bg, mode)
    c.diff_removed_bg = utils.process_color(M.vscode_colors.diff_removed_bg, bg, mode)
    
    -- Search and selection
    c.find_match_bg = utils.process_color(M.vscode_colors.find_match_bg, bg, mode)
    c.find_match_highlight_bg = utils.process_color(M.vscode_colors.find_match_highlight_bg, bg, mode)
    c.find_range_highlight_bg = utils.process_color(M.vscode_colors.find_range_highlight_bg, bg, mode)
    c.selection_bg = utils.process_color(M.vscode_colors.selection_bg, bg, mode)
    c.selection_highlight_bg = utils.process_color(M.vscode_colors.selection_highlight_bg, bg, mode)
    c.inactive_selection_bg = utils.process_color(M.vscode_colors.inactive_selection_bg, bg, mode)
    
    -- Editor UI elements
    c.word_highlight_bg = utils.process_color(M.vscode_colors.word_highlight_bg, bg, mode)
    c.word_highlight_strong_bg = utils.process_color(M.vscode_colors.word_highlight_strong_bg, bg, mode)
    c.snippet_highlight_bg = utils.process_color(M.vscode_colors.snippet_highlight_bg, bg, mode)
    c.bracket_match_border = utils.process_color(M.vscode_colors.bracket_match_border, bg, mode)
    
    -- Borders and guides
    c.group_border = utils.process_color(M.vscode_colors.group_border, bg, mode)
    c.tabs_border = utils.process_color(M.vscode_colors.tabs_border, ui_bg, mode)
    c.editorIndentGuide_bg = utils.process_color(M.vscode_colors.editorIndentGuide_bg, bg, mode)
    c.editorWhitespace_fg = utils.process_color(M.vscode_colors.editorWhitespace_fg, bg, mode)
    
    -- Lists and menus
    c.list_active_selection_bg = utils.process_color(M.vscode_colors.list_active_selection_bg, ui_bg, mode)
    c.list_inactive_selection_bg = utils.process_color(M.vscode_colors.list_inactive_selection_bg, ui_bg, mode)
    c.list_hover_bg = utils.process_color(M.vscode_colors.list_hover_bg, ui_bg, mode)
    c.menubar_selection_bg = utils.process_color(M.vscode_colors.menubar_selection_bg, ui_bg, mode)
    
    -- Input
    c.input_bg = utils.process_color(M.vscode_colors.input_bg, ui_bg, mode)
    c.input_placeholder_fg = utils.process_color(M.vscode_colors.input_placeholder_fg, ui_bg, mode)
    
    -- Scrollbar
    c.scrollbar_slider_bg = utils.process_color(M.vscode_colors.scrollbar_slider_bg, bg, mode)
    c.scrollbar_slider_hover_bg = utils.process_color(M.vscode_colors.scrollbar_slider_hover_bg, bg, mode)
    c.scrollbar_slider_active_bg = utils.process_color(M.vscode_colors.scrollbar_slider_active_bg, bg, mode)
    
    -- Terminal
    c.terminal_fg = utils.process_color(M.vscode_colors.terminal_fg, ui_bg, mode)
    c.terminal_selection_bg = utils.process_color(M.vscode_colors.terminal_selection_bg, ui_bg, mode)
    c.terminal_cursor_bg = utils.process_color(M.vscode_colors.terminal_cursor_bg, ui_bg, mode)
    
    -- Status bar and title bar
    c.statusbar_fg = utils.process_color(M.vscode_colors.statusbar_fg, ui_bg, mode)
    c.titlebar_fg = utils.process_color(M.vscode_colors.titlebar_fg, ui_bg, mode)
    c.titlebar_inactive_fg = utils.process_color(M.vscode_colors.titlebar_inactive_fg, ui_bg, mode)
    
    -- Other UI elements
    c.panel_title_inactive_fg = utils.process_color(M.vscode_colors.panel_title_inactive_fg, ui_bg, mode)
    c.sidebar_fg = utils.process_color(M.vscode_colors.sidebar_fg, ui_bg, mode)
    c.tree_indent_guides = utils.process_color(M.vscode_colors.tree_indent_guides, ui_bg, mode)
    c.widget_shadow = utils.process_color(M.vscode_colors.widget_shadow, ui_bg, mode)
    
    -- Merge colors
    c.merge_current_content_bg = utils.process_color(M.vscode_colors.merge_current_content_bg, bg, mode)
    c.merge_current_header_bg = utils.process_color(M.vscode_colors.merge_current_header_bg, bg, mode)
    c.merge_incoming_content_bg = utils.process_color(M.vscode_colors.merge_incoming_content_bg, bg, mode)
    c.merge_incoming_header_bg = utils.process_color(M.vscode_colors.merge_incoming_header_bg, bg, mode)
    
    -- Peek view
    c.peek_match_highlight_bg = utils.process_color(M.vscode_colors.peek_match_highlight_bg, ui_bg, mode)
    c.peek_result_line_fg = utils.process_color(M.vscode_colors.peek_result_line_fg, ui_bg, mode)
    
    -- Minimap
    c.minimap_find_match = utils.process_color(M.vscode_colors.minimap_find_match, M.vscode_colors.minimap_bg, mode)
    
    -- Marker navigation
    c.marker_navigation_bg = utils.process_color(M.vscode_colors.marker_navigation_bg, ui_bg, mode)
    c.marker_navigation_error_bg = utils.process_color(M.vscode_colors.marker_navigation_error_bg, ui_bg, mode)
    
    -- Tab colors
    c.tab_unfocused_active_fg = utils.process_color(M.vscode_colors.tab_unfocused_active_fg, ui_bg, mode)
    c.tab_unfocused_hover_bg = utils.process_color(M.vscode_colors.tab_unfocused_hover_bg, ui_bg, mode)
    c.tab_unfocused_inactive_fg = utils.process_color(M.vscode_colors.tab_unfocused_inactive_fg, ui_bg, mode)
    
    -- Group drop background
    c.group_drop_bg = utils.process_color(M.vscode_colors.group_drop_bg, bg, mode)
    c.list_drop_bg = utils.process_color(M.vscode_colors.list_drop_bg, ui_bg, mode)
    
    -- Other transparent elements
    c.panel_border = utils.process_color(M.vscode_colors.panel_border, ui_bg, mode)
    c.sidebar_border = utils.process_color(M.vscode_colors.sidebar_border, ui_bg, mode)
    c.statusbar_border = utils.process_color(M.vscode_colors.statusbar_border, ui_bg, mode)
    c.tab_border = utils.process_color(M.vscode_colors.tab_border, ui_bg, mode)
    c.titlebar_border = utils.process_color(M.vscode_colors.titlebar_border, ui_bg, mode)
    
    -- Gutter colors
    c.editorOverviewRuler_added = utils.process_color(M.vscode_colors.editorOverviewRuler_added, bg, mode)
    c.editorOverviewRuler_deleted = utils.process_color(M.vscode_colors.editorOverviewRuler_deleted, bg, mode)
    c.editorOverviewRuler_modified = utils.process_color(M.vscode_colors.editorOverviewRuler_modified, bg, mode)
    
    -- New colors (these are solid colors so no alpha processing needed)
    -- Minimap colors - these are solid colors, copy directly
    c.minimap_gutter_added_bg = M.vscode_colors.minimap_gutter_added_bg
    c.minimap_gutter_modified_bg = M.vscode_colors.minimap_gutter_modified_bg
    c.minimap_gutter_deleted_bg = M.vscode_colors.minimap_gutter_deleted_bg
    c.minimap_selection_highlight = M.vscode_colors.minimap_selection_highlight
    c.minimap_error_highlight = M.vscode_colors.minimap_error_highlight
    c.minimap_warning_highlight = M.vscode_colors.minimap_warning_highlight
    
    -- Button variants - solid colors
    c.button_secondary_bg = M.vscode_colors.button_secondary_bg
    c.button_secondary_fg = M.vscode_colors.button_secondary_fg
    c.button_secondary_hover_bg = M.vscode_colors.button_secondary_hover_bg
    
    -- Input validation colors - solid colors
    c.input_validation_error_fg = M.vscode_colors.input_validation_error_fg
    c.input_validation_warning_fg = M.vscode_colors.input_validation_warning_fg
    
    -- Extension button colors - solid colors
    c.extension_button_prominent_bg = M.vscode_colors.extension_button_prominent_bg
    c.extension_button_prominent_fg = M.vscode_colors.extension_button_prominent_fg
    c.extension_button_prominent_hover_bg = M.vscode_colors.extension_button_prominent_hover_bg
    
    return c
end

-- Get blend values for floating windows
function M.get_blend_values()
    return {
        normal_float = utils.extract_blend("#00000033") or 20,
        popup = utils.extract_blend("#00000055") or 33,
        menu = utils.extract_blend("#00000066") or 40,
    }
end

return M
