local utils = require('cursor-dark-anysphere.utils')

local M = {}

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
    editorWhitespace_fg = "#505050B3",
    editorIndentGuide_bg = "#404040B3",
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
}

-- Get processed colors based on transparency mode
---@param mode string 'blended', 'transparent', or 'opaque'
---@return table colors Processed color palette
function M.get_colors(mode)
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