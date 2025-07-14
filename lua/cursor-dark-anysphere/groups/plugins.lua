local M = {}

function M.setup(c, config)
    local utils = require('cursor-dark-anysphere.utils')
    local groups = {}
    
    -- Telescope
    if config.plugins.telescope then
        groups.TelescopeNormal = { fg = c.editor_fg, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopeBorder = { fg = c.gray2, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopePromptNormal = { fg = c.editor_fg, bg = c.gray1 }
        groups.TelescopePromptBorder = { fg = c.gray1, bg = c.gray1 }
        groups.TelescopePromptTitle = { fg = c.white, bg = c.gray1, bold = true }
        groups.TelescopePromptPrefix = { fg = c.blue2, bg = c.gray1 }
        groups.TelescopePromptCounter = { fg = c.gray7, bg = c.gray1 }
        groups.TelescopeResultsNormal = { fg = c.editor_fg, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopeResultsBorder = { fg = c.gray2, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopeResultsTitle = { fg = c.white, bg = config.transparencies.floats and c.ui_bg or c.ui_bg, bold = true }
        groups.TelescopePreviewNormal = { fg = c.editor_fg, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopePreviewBorder = { fg = c.gray2, bg = config.transparencies.floats and c.ui_bg or c.ui_bg }
        groups.TelescopePreviewTitle = { fg = c.white, bg = config.transparencies.floats and c.ui_bg or c.ui_bg, bold = true }
        groups.TelescopeSelection = { bg = c.list_active_selection_bg }
        groups.TelescopeSelectionCaret = { fg = c.blue2, bg = c.list_active_selection_bg }
        groups.TelescopeMultiSelection = { bg = c.list_inactive_selection_bg }
        groups.TelescopeMatching = { fg = c.blue2, bold = true }
    end
    
    -- nvim-tree
    if config.plugins.nvim_tree then
        groups.NvimTreeNormal = { fg = c.sidebar_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.NvimTreeNormalNC = { fg = c.sidebar_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.NvimTreeNormalFloat = { fg = c.sidebar_fg, bg = c.ui_bg }
        groups.NvimTreeCursorLine = { bg = c.list_active_selection_bg }
        groups.NvimTreeCursorColumn = { bg = c.list_active_selection_bg }
        groups.NvimTreeRootFolder = { fg = c.blue2, bold = true }
        groups.NvimTreeGitDirty = { fg = c.yellow1 }
        groups.NvimTreeGitNew = { fg = c.green1 }
        groups.NvimTreeGitDeleted = { fg = c.red1 }
        groups.NvimTreeGitStaged = { fg = c.green1 }
        groups.NvimTreeSpecialFile = { fg = c.yellow2, underline = true }
        groups.NvimTreeIndentMarker = { fg = c.tree_indent_guides }
        groups.NvimTreeImageFile = { fg = c.purple2 }
        groups.NvimTreeSymlink = { fg = c.blue2 }
        groups.NvimTreeFolderName = { fg = c.sidebar_fg }
        groups.NvimTreeFolderIcon = { fg = c.blue2 }
        groups.NvimTreeOpenedFolderName = { fg = c.blue2, bold = true }
        groups.NvimTreeEmptyFolderName = { fg = c.gray7 }
        groups.NvimTreeFileName = { fg = c.sidebar_fg }
        groups.NvimTreeFileIcon = { fg = c.sidebar_fg }
        groups.NvimTreeExecFile = { fg = c.green1 }
        
        groups.NvimTreeWinSeparator = { fg = c.sidebar_border, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.NvimTreeWindowPicker = { fg = c.white, bg = c.blue1, bold = true }
    end
    
    -- neo-tree
    if config.plugins.neo_tree then
        groups.NeoTreeNormal = { fg = c.sidebar_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.NeoTreeNormalNC = { fg = c.sidebar_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.NeoTreeDirectoryName = { fg = c.sidebar_fg }
        groups.NeoTreeDirectoryIcon = { fg = c.blue2 }
        groups.NeoTreeRootName = { fg = c.blue2, bold = true }
        groups.NeoTreeFileName = { fg = c.sidebar_fg }
        groups.NeoTreeFileIcon = { fg = c.sidebar_fg }
        groups.NeoTreeFileNameOpened = { fg = c.blue2 }
        groups.NeoTreeSymbolicLinkTarget = { fg = c.blue2 }
        groups.NeoTreeIndentMarker = { fg = c.tree_indent_guides }
        groups.NeoTreeGitAdded = { fg = c.green1 }
        groups.NeoTreeGitConflict = { fg = c.red1 }
        groups.NeoTreeGitDeleted = { fg = c.red1 }
        groups.NeoTreeGitModified = { fg = c.yellow1 }
        groups.NeoTreeGitUnstaged = { fg = c.yellow1 }
        groups.NeoTreeGitUntracked = { fg = c.blue2 }
        groups.NeoTreeGitStaged = { fg = c.green1 }
        groups.NeoTreeFloatBorder = { fg = c.gray2 }
        groups.NeoTreeFloatTitle = { fg = c.white, bold = true }
        groups.NeoTreeTitleBar = { fg = c.white, bg = c.ui_bg }
    end
    
    -- nvim-cmp
    if config.plugins.nvim_cmp then
        groups.CmpItemAbbrDefault = { fg = c.editor_fg }
        groups.CmpItemAbbrDeprecated = { fg = c.gray7, strikethrough = true }
        groups.CmpItemAbbrMatch = { fg = c.blue2, bold = true }
        groups.CmpItemAbbrMatchFuzzy = { fg = c.blue2 }
        groups.CmpItemKindDefault = { fg = c.gray7 }
        groups.CmpItemMenu = { fg = c.gray7 }
        groups.CmpItemKindText = { fg = c.editor_fg }
        groups.CmpItemKindMethod = { fg = c.yellow2 }
        groups.CmpItemKindFunction = { fg = c.yellow2 }
        groups.CmpItemKindConstructor = { fg = c.yellow2 }
        groups.CmpItemKindField = { fg = c.purple3 }
        groups.CmpItemKindVariable = { fg = c.blue5 }
        groups.CmpItemKindClass = { fg = c.blue3 }
        groups.CmpItemKindInterface = { fg = c.blue3 }
        groups.CmpItemKindModule = { fg = c.yellow2 }
        groups.CmpItemKindProperty = { fg = c.purple3 }
        groups.CmpItemKindUnit = { fg = c.yellow3 }
        groups.CmpItemKindValue = { fg = c.yellow3 }
        groups.CmpItemKindEnum = { fg = c.blue3 }
        groups.CmpItemKindKeyword = { fg = c.blue4 }
        groups.CmpItemKindSnippet = { fg = c.green1 }
        groups.CmpItemKindColor = { fg = c.pink }
        groups.CmpItemKindFile = { fg = c.editor_fg }
        groups.CmpItemKindReference = { fg = c.editor_fg }
        groups.CmpItemKindFolder = { fg = c.blue2 }
        groups.CmpItemKindEnumMember = { fg = c.editor_fg }
        groups.CmpItemKindConstant = { fg = c.yellow3 }
        groups.CmpItemKindStruct = { fg = c.blue3 }
        groups.CmpItemKindEvent = { fg = c.yellow2 }
        groups.CmpItemKindOperator = { fg = c.editor_fg }
        groups.CmpItemKindTypeParameter = { fg = c.blue3 }
    end
    
    -- GitSigns
    if config.plugins.gitsigns then
        groups.GitSignsAdd = { fg = c.green1 }
        groups.GitSignsChange = { fg = c.yellow1 }
        groups.GitSignsDelete = { fg = c.red1 }
        groups.GitSignsAddNr = { fg = c.green1 }
        groups.GitSignsChangeNr = { fg = c.yellow1 }
        groups.GitSignsDeleteNr = { fg = c.red1 }
        groups.GitSignsAddLn = { bg = c.diff_added_bg }
        groups.GitSignsChangeLn = { bg = c.merge_current_content_bg }
        groups.GitSignsDeleteLn = { bg = c.diff_removed_bg }
        groups.GitSignsAddInline = { bg = utils.lighten(c.green1, 20) }
        groups.GitSignsChangeInline = { bg = utils.lighten(c.yellow1, 20) }
        groups.GitSignsDeleteInline = { bg = utils.lighten(c.red1, 20) }
    end
    
    -- indent-blankline (handled in editor.lua)
    
    -- Dashboard
    if config.plugins.dashboard then
        groups.DashboardHeader = { fg = c.blue2 }
        groups.DashboardCenter = { fg = c.editor_fg }
        groups.DashboardFooter = { fg = c.gray7 }
        groups.DashboardKey = { fg = c.yellow2 }
        groups.DashboardDesc = { fg = c.editor_fg }
        groups.DashboardIcon = { fg = c.blue2 }
    end
    
    -- Which-key
    if config.plugins.which_key then
        groups.WhichKey = { fg = c.blue2 }
        groups.WhichKeyGroup = { fg = c.yellow2 }
        groups.WhichKeyDesc = { fg = c.editor_fg }
        groups.WhichKeySeperator = { fg = c.gray7 }
        groups.WhichKeySeparator = { fg = c.gray7 }
        groups.WhichKeyFloat = { bg = c.ui_bg }
        groups.WhichKeyValue = { fg = c.gray7 }
    end
    
    -- Trouble
    if config.plugins.trouble then
        groups.TroubleText = { fg = c.editor_fg }
        groups.TroubleCount = { fg = c.purple2, bold = true }
        groups.TroubleNormal = { fg = c.editor_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.TroubleSignError = { fg = c.red1 }
        groups.TroubleSignWarning = { fg = c.yellow1 }
        groups.TroubleSignInformation = { fg = c.blue2 }
        groups.TroubleSignHint = { fg = c.gray7 }
        groups.TroubleSignOther = { fg = c.purple2 }
        groups.TroubleError = { fg = c.red1 }
        groups.TroubleWarning = { fg = c.yellow1 }
        groups.TroubleInformation = { fg = c.blue2 }
        groups.TroubleHint = { fg = c.gray7 }
        groups.TroubleLocation = { fg = c.gray7 }
        groups.TroubleFile = { fg = c.blue2 }
        groups.TroubleFoldIcon = { fg = c.gray7 }
        groups.TroubleIndent = { fg = c.tree_indent_guides }
        groups.TroubleCode = { fg = c.gray7 }
    end
    
    -- Todo-comments
    if config.plugins.todo_comments then
        groups.TodoBgTODO = { fg = c.black, bg = c.yellow1, bold = true }
        groups.TodoFgTODO = { fg = c.yellow1 }
        groups.TodoSignTODO = { fg = c.yellow1 }
        groups.TodoBgFIX = { fg = c.black, bg = c.red1, bold = true }
        groups.TodoFgFIX = { fg = c.red1 }
        groups.TodoSignFIX = { fg = c.red1 }
        groups.TodoBgHACK = { fg = c.black, bg = c.yellow2, bold = true }
        groups.TodoFgHACK = { fg = c.yellow2 }
        groups.TodoSignHACK = { fg = c.yellow2 }
        groups.TodoBgWARN = { fg = c.black, bg = c.yellow1, bold = true }
        groups.TodoFgWARN = { fg = c.yellow1 }
        groups.TodoSignWARN = { fg = c.yellow1 }
        groups.TodoBgPERF = { fg = c.black, bg = c.purple2, bold = true }
        groups.TodoFgPERF = { fg = c.purple2 }
        groups.TodoSignPERF = { fg = c.purple2 }
        groups.TodoBgNOTE = { fg = c.black, bg = c.blue2, bold = true }
        groups.TodoFgNOTE = { fg = c.blue2 }
        groups.TodoSignNOTE = { fg = c.blue2 }
        groups.TodoBgTEST = { fg = c.black, bg = c.green1, bold = true }
        groups.TodoFgTEST = { fg = c.green1 }
        groups.TodoSignTEST = { fg = c.green1 }
    end
    
    -- Lazy.nvim
    if config.plugins.lazy then
        groups.LazyH1 = { fg = c.white, bg = c.gray2, bold = true }
        groups.LazyH2 = { fg = c.blue2, bold = true }
        groups.LazyButton = { fg = c.editor_fg, bg = c.gray1 }
        groups.LazyButtonActive = { fg = c.white, bg = c.gray2, bold = true }
        groups.LazySpecial = { fg = c.blue2 }
        groups.LazyProgressDone = { fg = c.green1 }
        groups.LazyProgressTodo = { fg = c.gray3 }
        groups.LazyProp = { fg = c.gray7 }
        groups.LazyReasonPlugin = { fg = c.purple2 }
        groups.LazyReasonEvent = { fg = c.yellow2 }
        groups.LazyReasonKeys = { fg = c.blue2 }
        groups.LazyReasonStart = { fg = c.green1 }
        groups.LazyReasonSource = { fg = c.blue2 }
        groups.LazyReasonFt = { fg = c.purple2 }
        groups.LazyReasonCmd = { fg = c.yellow2 }
        groups.LazyReasonImport = { fg = c.editor_fg }
        groups.LazyReasonRequire = { fg = c.red1 }
        groups.LazyDir = { fg = c.blue2 }
        groups.LazyUrl = { fg = c.blue2, underline = true }
        groups.LazyCommit = { fg = c.green1 }
        groups.LazyNoCond = { fg = c.red1 }
        groups.LazyLocal = { fg = c.yellow2 }
    end
    
    -- Mini.nvim
    if config.plugins.mini then
        -- mini.indentscope
        groups.MiniIndentscopeSymbol = { fg = c.gray3 }
        groups.MiniIndentscopePrefix = { nocombine = true }
        
        -- mini.starter
        groups.MiniStarterHeader = { fg = c.blue2 }
        groups.MiniStarterFooter = { fg = c.gray7 }
        groups.MiniStarterItem = { fg = c.editor_fg }
        groups.MiniStarterItemBullet = { fg = c.gray7 }
        groups.MiniStarterItemPrefix = { fg = c.yellow2 }
        groups.MiniStarterSection = { fg = c.blue2 }
        groups.MiniStarterQuery = { fg = c.green1 }
        
        -- mini.statusline
        groups.MiniStatuslineModeNormal = { fg = c.black, bg = c.blue2, bold = true }
        groups.MiniStatuslineModeInsert = { fg = c.black, bg = c.green1, bold = true }
        groups.MiniStatuslineModeVisual = { fg = c.black, bg = c.purple2, bold = true }
        groups.MiniStatuslineModeReplace = { fg = c.black, bg = c.red1, bold = true }
        groups.MiniStatuslineModeCommand = { fg = c.black, bg = c.yellow2, bold = true }
        groups.MiniStatuslineModeOther = { fg = c.black, bg = c.gray7, bold = true }
        groups.MiniStatuslineDevinfo = { fg = c.editor_fg, bg = c.gray1 }
        groups.MiniStatuslineFilename = { fg = c.editor_fg, bg = c.gray1 }
        groups.MiniStatuslineFileinfo = { fg = c.editor_fg, bg = c.gray1 }
        groups.MiniStatuslineInactive = { fg = c.gray7, bg = c.ui_bg }
        
        -- mini.tabline
        groups.MiniTablineCurrent = { fg = c.white, bg = c.editor_bg }
        groups.MiniTablineVisible = { fg = c.editor_fg, bg = c.gray1 }
        groups.MiniTablineHidden = { fg = c.gray7, bg = c.ui_bg }
        groups.MiniTablineModifiedCurrent = { fg = c.yellow1, bg = c.editor_bg }
        groups.MiniTablineModifiedVisible = { fg = c.yellow1, bg = c.gray1 }
        groups.MiniTablineModifiedHidden = { fg = c.yellow1, bg = c.ui_bg }
        groups.MiniTablineFill = { bg = c.ui_bg }
        groups.MiniTablineTabpagesection = { fg = c.white, bg = c.gray2, bold = true }
        
        -- mini.pick
        groups.MiniPickBorder = { fg = c.gray2 }
        groups.MiniPickBorderBusy = { fg = c.yellow2 }
        groups.MiniPickBorderText = { fg = c.white, bold = true }
        groups.MiniPickHeader = { fg = c.blue2 }
        groups.MiniPickMatchCurrent = { bg = c.list_active_selection_bg }
        groups.MiniPickMatchMarked = { bg = c.list_inactive_selection_bg }
        groups.MiniPickMatchRanges = { fg = c.blue2, bold = true }
        groups.MiniPickNormal = { fg = c.editor_fg }
        groups.MiniPickPreviewLine = { bg = c.gray1 }
        groups.MiniPickPreviewRegion = { bg = c.gray2 }
        groups.MiniPickPrompt = { fg = c.blue2 }
    end
    
    
    -- snacks.nvim
    if config.plugins.snacks then
        -- Picker/Explorer highlights (used by snacks explorer)
        groups.SnacksPickerFile = { fg = c.sidebar_fg }
        groups.SnacksPickerDir = { fg = c.blue2, bold = true }
        groups.SnacksPickerPathHidden = { fg = c.gray4 }
        groups.SnacksPickerPathIgnored = { fg = c.gray3 }
        groups.SnacksPickerGitStatusUntracked = { fg = c.green1 }
        groups.SnacksPickerGitStatusModified = { fg = c.yellow1 }
        groups.SnacksPickerGitStatusDeleted = { fg = c.red1 }
        groups.SnacksPickerGitStatusStaged = { fg = c.green1 }
        groups.SnacksPickerGitStatusRenamed = { fg = c.cyan }
        groups.SnacksPickerGitStatusAdded = { fg = c.green1 }
        
        -- Explorer specific highlights
        groups.SnacksExplorerFile = { fg = c.sidebar_fg }
        groups.SnacksExplorerDir = { fg = c.blue2, bold = true }
        groups.SnacksExplorerNormal = { fg = c.sidebar_fg, bg = config.transparencies.sidebar and "NONE" or c.ui_bg }
        groups.SnacksExplorerTitle = { fg = c.white, bold = true }
        groups.SnacksExplorerBorder = { fg = c.sidebar_border }
        
        -- Dashboard highlights
        groups.SnacksDashboardNormal = { fg = c.editor_fg, bg = config.transparencies.floats and "NONE" or c.ui_bg }
        groups.SnacksDashboardDesc = { fg = c.blue2 }
        groups.SnacksDashboardFile = { fg = c.sidebar_fg }
        groups.SnacksDashboardDir = { fg = c.blue2 }
        groups.SnacksDashboardFooter = { fg = c.gray4 }
        groups.SnacksDashboardHeader = { fg = c.white, bold = true }
        groups.SnacksDashboardIcon = { fg = c.blue2 }
        groups.SnacksDashboardKey = { fg = c.yellow2 }
        groups.SnacksDashboardTerminal = { fg = c.terminal_fg }
        groups.SnacksDashboardSpecial = { fg = c.purple2 }
        
        -- Notification highlights
        groups.SnacksNotifierInfo = { fg = c.blue2 }
        groups.SnacksNotifierWarn = { fg = c.yellow1 }
        groups.SnacksNotifierError = { fg = c.red1 }
        groups.SnacksNotifierDebug = { fg = c.gray4 }
        groups.SnacksNotifierTrace = { fg = c.purple2 }
        
        -- Input highlights
        groups.SnacksInputNormal = { fg = c.editor_fg, bg = c.ui_bg }
        groups.SnacksInputBorder = { fg = c.gray2 }
        groups.SnacksInputTitle = { fg = c.white, bold = true }
    end
    
    -- Lualine (theme should be set separately in lualine config)
    
    return groups
end

return M