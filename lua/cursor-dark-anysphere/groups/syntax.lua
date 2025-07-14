local M = {}

function M.setup(c, config)
    local groups = {
        -- Comments
        Comment = vim.tbl_extend("force", { fg = c.comment }, config.styles.comments or {}),
        
        -- Constants
        Constant = { fg = c.yellow3 },
        String = vim.tbl_extend("force", { fg = c.pink }, config.styles.strings or {}),
        Character = { fg = c.pink },
        Number = vim.tbl_extend("force", { fg = c.yellow3 }, config.styles.numbers or {}),
        Boolean = vim.tbl_extend("force", { fg = c.blue4 }, config.styles.booleans or {}),
        Float = { fg = c.yellow3 },
        
        -- Identifiers
        Identifier = { fg = c.editor_fg },
        Function = vim.tbl_extend("force", { fg = c.yellow2 }, config.styles.functions or {}),
        
        -- Statements
        Statement = { fg = c.blue4 },
        Conditional = { fg = c.blue4 },
        Repeat = { fg = c.blue4 },
        Label = { fg = c.blue4 },
        Operator = vim.tbl_extend("force", { fg = c.editor_fg }, config.styles.operators or {}),
        Keyword = vim.tbl_extend("force", { fg = c.blue4 }, config.styles.keywords or {}),
        Exception = { fg = c.blue4 },
        
        -- Preproc
        PreProc = { fg = c.green2 },
        Include = { fg = c.purple2 },
        Define = { fg = c.green2 },
        Macro = { fg = c.green2 },
        PreCondit = { fg = c.green2 },
        
        -- Types
        Type = vim.tbl_extend("force", { fg = c.blue3 }, config.styles.types or {}),
        StorageClass = { fg = c.blue4 },
        Structure = { fg = c.blue3 },
        Typedef = { fg = c.blue3 },
        
        -- Special
        Special = { fg = c.yellow4 },
        SpecialChar = { fg = c.editor_fg },
        Tag = { fg = c.blue3 },
        Delimiter = { fg = c.editor_fg },
        SpecialComment = { fg = c.comment },
        Debug = { fg = c.blue4 },
        
        -- Underlined
        Underlined = { underline = true },
        
        -- Ignore
        Ignore = { fg = c.gray3 },
        
        -- Error
        Error = { fg = c.red1 },
        
        -- Todo
        Todo = { fg = c.yellow1, bold = true },
        
        -- Additional semantic highlights
        Parameter = vim.tbl_extend("force", { fg = c.yellow4 }, config.styles.parameters or {}),
        Property = { fg = c.purple3 },
        Field = { fg = c.purple3 },
        Method = vim.tbl_extend("force", { fg = c.yellow2 }, config.styles.functions or {}),
        Constructor = { fg = c.yellow2 },
        Namespace = { fg = c.editor_fg },
        Annotation = { fg = c.green2 },
        Decorator = { fg = c.green2 },
        
        -- Language-specific overrides based on VSCode theme
        -- Python
        pythonBuiltin = { fg = c.blue4 },
        pythonFunction = { fg = c.yellow3 },
        pythonDecorator = { fg = c.green2 },
        pythonDecoratorName = { fg = c.green2 },
        pythonSelf = { fg = c.red4 },
        pythonClass = { fg = c.yellow3 },
        
        -- JavaScript/TypeScript
        jsFunction = { fg = c.yellow3 },
        jsFuncCall = { fg = c.purple2 },
        jsThis = { fg = c.red5 },
        jsSuper = { fg = c.red5 },
        jsGlobalObjects = { fg = c.yellow2 },
        jsBuiltins = { fg = c.blue4 },
        
        tsTypeBuiltin = { fg = c.blue4 },
        tsType = { fg = c.blue3 },
        
        -- C/C++
        cType = { fg = c.blue3 },
        cppFunction = { fg = "#efefef", bold = true },
        cppMethod = { fg = c.blue3 },
        cppThis = { fg = c.blue4 },
        
        -- Rust
        rustSelf = { fg = c.editor_fg },
        rustSuper = { fg = c.editor_fg },
        rustLifetime = { fg = c.yellow2 },
        rustDerive = { fg = c.green2 },
        rustAttribute = { fg = c.green2 },
        rustMacro = { fg = c.green2 },
        
        -- Go
        goFunction = { fg = c.yellow3 },
        goMethod = { fg = c.yellow3 },
        goPackage = { fg = c.yellow2 },
        
        -- HTML/XML
        htmlTag = { fg = c.gray6 },
        htmlEndTag = { fg = c.gray6 },
        htmlTagName = { fg = c.blue3 },
        htmlArg = { fg = c.purple2 },
        htmlSpecialChar = { fg = c.editor_fg },
        
        -- CSS
        cssClassName = { fg = c.yellow4 },
        cssClassNameDot = { fg = c.yellow4 },
        cssProp = { fg = c.blue3 },
        cssAttr = { fg = c.pink },
        cssUnitDecorators = { fg = c.yellow3 },
        cssImportant = { fg = c.blue4 },
        
        -- JSON
        jsonKeyword = { fg = c.blue4 },
        jsonString = { fg = c.pink },
        jsonBoolean = { fg = c.blue4 },
        jsonNull = { fg = c.blue4 },
        jsonNumber = { fg = c.yellow3 },
        
        -- YAML
        yamlKey = { fg = c.blue4 },
        yamlConstant = { fg = c.blue4 },
        
        -- Markdown
        markdownH1 = { fg = c.editor_fg, bold = true },
        markdownH2 = { fg = c.editor_fg, bold = true },
        markdownH3 = { fg = c.editor_fg, bold = true },
        markdownH4 = { fg = c.editor_fg, bold = true },
        markdownH5 = { fg = c.editor_fg, bold = true },
        markdownH6 = { fg = c.editor_fg, bold = true },
        markdownHeadingDelimiter = { fg = c.editor_fg },
        markdownCode = { fg = c.pink },
        markdownCodeBlock = { fg = c.pink },
        markdownCodeDelimiter = { fg = c.pink },
        markdownBlockquote = { fg = c.comment },
        markdownListMarker = { fg = c.editor_fg },
        markdownOrderedListMarker = { fg = c.editor_fg },
        markdownRule = { fg = c.editor_fg },
        markdownHeadingRule = { fg = c.editor_fg },
        markdownUrlDelimiter = { fg = c.editor_fg },
        markdownLinkDelimiter = { fg = c.editor_fg },
        markdownLinkTextDelimiter = { fg = c.editor_fg },
        markdownUrl = { fg = c.blue4, underline = true },
        markdownUrlTitleDelimiter = { fg = c.editor_fg },
        markdownLinkText = { fg = c.purple2 },
        markdownIdDeclaration = { fg = c.editor_fg },
    }
    
    return groups
end

return M