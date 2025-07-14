local M = {}

function M.setup(c, config)
    local utils = require('cursor-dark-anysphere.utils')
    local transparent_bg = config.transparent and "NONE" or nil
    
    local groups = {
        -- Editor basics
        Normal = { fg = c.editor_fg, bg = transparent_bg or c.editor_bg },
        NormalNC = { fg = c.editor_fg, bg = transparent_bg or c.editor_bg },
        NormalFloat = { 
            fg = c.editor_fg, 
            bg = config.transparencies.floats and c.ui_bg or (transparent_bg or c.ui_bg),
            blend = config.transparencies.floats and 20 or nil
        },
        FloatBorder = { fg = c.gray2, bg = config.transparencies.floats and c.ui_bg or (transparent_bg or c.ui_bg) },
        FloatTitle = { fg = c.white, bg = config.transparencies.floats and c.ui_bg or (transparent_bg or c.ui_bg) },
        
        -- Cursor and lines
        Cursor = { fg = c.black, bg = c.white },
        CursorIM = { fg = c.black, bg = c.white },
        CursorLine = { bg = "#292929" },
        CursorLineNr = { fg = c.white, bg = "NONE", bold = true },
        CursorColumn = { bg = "#292929" },
        
        -- Line numbers
        LineNr = { fg = c.gray3 },
        LineNrAbove = { fg = c.gray3 },
        LineNrBelow = { fg = c.gray3 },
        
        -- Sign column
        SignColumn = { fg = c.gray3, bg = transparent_bg or c.editor_bg },
        SignColumnSB = { fg = c.gray3, bg = config.transparencies.sidebar and "NONE" or c.ui_bg },
        
        -- Folding
        Folded = { fg = c.gray7, bg = c.gray1 },
        FoldColumn = { fg = c.gray3, bg = transparent_bg or c.editor_bg },
        
        -- Status line
        StatusLine = { 
            fg = c.statusbar_fg, 
            bg = config.transparencies.statusline and "NONE" or c.ui_bg 
        },
        StatusLineNC = { 
            fg = c.gray3, 
            bg = config.transparencies.statusline and "NONE" or c.ui_bg 
        },
        StatusLineTerm = { 
            fg = c.statusbar_fg, 
            bg = config.transparencies.statusline and "NONE" or c.ui_bg 
        },
        StatusLineTermNC = { 
            fg = c.gray3, 
            bg = config.transparencies.statusline and "NONE" or c.ui_bg 
        },
        
        -- Tab line
        TabLine = { fg = c.gray3, bg = c.ui_bg },
        TabLineFill = { bg = c.ui_bg },
        TabLineSel = { fg = c.white, bg = c.editor_bg },
        
        -- Window separators
        WinSeparator = { fg = c.group_border, bg = transparent_bg or c.editor_bg },
        VertSplit = { fg = c.group_border, bg = transparent_bg or c.editor_bg },
        
        -- Popup menu
        Pmenu = { 
            fg = c.editor_fg, 
            bg = config.transparencies.popups and c.ui_bg or c.ui_bg,
            blend = config.transparencies.popups and 20 or nil
        },
        PmenuSel = { fg = c.white, bg = c.gray2 },
        PmenuSbar = { bg = c.gray1 },
        PmenuThumb = { bg = c.gray2 },
        
        -- Wild menu
        WildMenu = { fg = c.white, bg = c.gray2 },
        
        -- Messages
        ErrorMsg = { fg = c.red1 },
        WarningMsg = { fg = c.yellow1 },
        ModeMsg = { fg = c.editor_fg },
        MoreMsg = { fg = c.blue2 },
        Question = { fg = c.blue2 },
        
        -- Search
        Search = { fg = c.black, bg = c.find_match_bg },
        IncSearch = { fg = c.black, bg = c.find_match_bg },
        CurSearch = { fg = c.black, bg = c.find_match_bg },
        Substitute = { fg = c.black, bg = c.yellow2 },
        
        -- Selection
        Visual = { bg = c.selection_bg },
        VisualNOS = { bg = c.selection_bg },
        
        -- Match
        MatchParen = { fg = "NONE", bg = "NONE", sp = c.bracket_match_border, underline = true },
        
        -- Diff
        DiffAdd = { bg = c.diff_added_bg },
        DiffChange = { bg = c.merge_current_content_bg },
        DiffDelete = { bg = c.diff_removed_bg },
        DiffText = { bg = c.merge_current_header_bg },
        
        -- Spelling
        SpellBad = { sp = c.red1, undercurl = true },
        SpellCap = { sp = c.yellow1, undercurl = true },
        SpellLocal = { sp = c.blue2, undercurl = true },
        SpellRare = { sp = c.purple2, undercurl = true },
        
        -- Special characters
        NonText = { fg = config.ending_tildes and c.gray3 or c.editor_bg },
        EndOfBuffer = { fg = config.ending_tildes and c.gray3 or c.editor_bg },
        Whitespace = { fg = c.editorWhitespace_fg },
        SpecialKey = { fg = c.editorWhitespace_fg },
        
        -- Quick fix
        QuickFixLine = { bg = c.gray1 },
        qfLineNr = { fg = c.gray3 },
        qfFileName = { fg = c.blue2 },
        
        -- Conceal
        Conceal = { fg = c.gray3 },
        
        -- Directory
        Directory = { fg = c.blue2 },
        
        -- Title
        Title = { fg = c.blue2, bold = true },
        
        -- Color column
        ColorColumn = { bg = c.gray1 },
        
        -- Indent guides
        IndentBlanklineChar = { fg = c.editorIndentGuide_bg, nocombine = true },
        IndentBlanklineContextChar = { fg = c.gray3, nocombine = true },
        IblIndent = { fg = c.editorIndentGuide_bg, nocombine = true },
        IblWhitespace = { fg = c.editorIndentGuide_bg, nocombine = true },
        IblScope = { fg = c.gray3, nocombine = true },
        
        -- Snacks indent guides
        SnacksIndent = { fg = c.editorIndentGuide_bg, nocombine = true },
        SnacksIndentScope = { fg = c.gray3, nocombine = true },
        
        -- Winbar
        WinBar = { fg = c.editor_fg, bg = transparent_bg or c.editor_bg },
        WinBarNC = { fg = c.gray7, bg = transparent_bg or c.editor_bg },
    }
    
    -- Neovim 0.9+ diagnostic highlights
    groups.DiagnosticError = { fg = c.red1 }
    groups.DiagnosticWarn = { fg = c.yellow1 }
    groups.DiagnosticInfo = { fg = c.blue2 }
    groups.DiagnosticHint = { fg = c.gray7 }
    groups.DiagnosticOk = { fg = c.green1 }
    
    groups.DiagnosticVirtualTextError = { fg = c.red1, bg = utils.blend(c.red1, c.editor_bg, 0.1) }
    groups.DiagnosticVirtualTextWarn = { fg = c.yellow1, bg = utils.blend(c.yellow1, c.editor_bg, 0.1) }
    groups.DiagnosticVirtualTextInfo = { fg = c.blue2, bg = utils.blend(c.blue2, c.editor_bg, 0.1) }
    groups.DiagnosticVirtualTextHint = { fg = c.gray7, bg = utils.blend(c.gray7, c.editor_bg, 0.1) }
    groups.DiagnosticVirtualTextOk = { fg = c.green1, bg = utils.blend(c.green1, c.editor_bg, 0.1) }
    
    groups.DiagnosticUnderlineError = { sp = c.red1, undercurl = true }
    groups.DiagnosticUnderlineWarn = { sp = c.yellow1, undercurl = true }
    groups.DiagnosticUnderlineInfo = { sp = c.blue2, undercurl = true }
    groups.DiagnosticUnderlineHint = { sp = c.gray7, undercurl = true }
    groups.DiagnosticUnderlineOk = { sp = c.green1, undercurl = true }
    
    groups.DiagnosticFloatingError = { fg = c.red1 }
    groups.DiagnosticFloatingWarn = { fg = c.yellow1 }
    groups.DiagnosticFloatingInfo = { fg = c.blue2 }
    groups.DiagnosticFloatingHint = { fg = c.gray7 }
    groups.DiagnosticFloatingOk = { fg = c.green1 }
    
    groups.DiagnosticSignError = { fg = c.red1 }
    groups.DiagnosticSignWarn = { fg = c.yellow1 }
    groups.DiagnosticSignInfo = { fg = c.blue2 }
    groups.DiagnosticSignHint = { fg = c.gray7 }
    groups.DiagnosticSignOk = { fg = c.green1 }
    
    -- LSP
    groups.LspReferenceText = { bg = c.word_highlight_bg }
    groups.LspReferenceRead = { bg = c.word_highlight_bg }
    groups.LspReferenceWrite = { bg = c.word_highlight_strong_bg }
    
    groups.LspCodeLens = { fg = c.gray3 }
    groups.LspCodeLensSeparator = { fg = c.gray3 }
    
    groups.LspSignatureActiveParameter = { bg = c.gray2 }
    
    -- Inlay hints
    groups.LspInlayHint = { fg = c.gray3, bg = transparent_bg or "NONE" }
    
    -- Minimap highlight groups (custom groups for minimap functionality)
    groups.MinimapGutterAdd = { fg = c.minimap_gutter_added_bg }
    groups.MinimapGutterChange = { fg = c.minimap_gutter_modified_bg }
    groups.MinimapGutterDelete = { fg = c.minimap_gutter_deleted_bg }
    groups.MinimapSelectionHighlight = { bg = c.minimap_selection_highlight }
    groups.MinimapErrorHighlight = { fg = c.minimap_error_highlight }
    groups.MinimapWarningHighlight = { fg = c.minimap_warning_highlight }
    
    -- Button variant highlights (for floating windows and popups)
    groups.FloatermBorder = { fg = c.button_secondary_fg, bg = c.button_secondary_bg }
    groups.ButtonSecondary = { fg = c.button_secondary_fg, bg = c.button_secondary_bg }
    groups.ButtonSecondaryHover = { fg = c.button_secondary_fg, bg = c.button_secondary_hover_bg }
    
    -- Input validation highlights (for command line and prompts)
    groups.ErrorFloat = { fg = c.input_validation_error_fg, bg = c.red2 }
    groups.WarningFloat = { fg = c.input_validation_warning_fg, bg = c.yellow6 }
    groups.MsgAreaError = { fg = c.input_validation_error_fg, bg = c.red2 }
    groups.MsgAreaWarn = { fg = c.input_validation_warning_fg, bg = c.yellow6 }
    
    -- Extension/plugin button highlights (for plugin managers and UI)
    groups.PluginButton = { fg = c.extension_button_prominent_fg, bg = c.extension_button_prominent_bg }
    groups.PluginButtonHover = { fg = c.extension_button_prominent_fg, bg = c.extension_button_prominent_hover_bg }
    groups.LazyButton = { fg = c.extension_button_prominent_fg, bg = c.extension_button_prominent_bg }
    groups.LazyButtonActive = { fg = c.extension_button_prominent_fg, bg = c.extension_button_prominent_hover_bg }
    
    return groups
end

return M
