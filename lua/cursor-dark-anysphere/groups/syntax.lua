local M = {}
local utils = require('cursor-dark-anysphere.utils')

function M.setup(c, config)
    -- Helper function for safe style merging
    local function safe_style_merge(base, style_config)
        local success, result = pcall(function()
            return utils.safe_tbl_extend("force", base, style_config or {})
        end)
        
        if success and result then
            return result
        else
            -- Fallback: manual merge
            local merged = {}
            for k, v in pairs(base) do
                merged[k] = v
            end
            if style_config then
                for k, v in pairs(style_config) do
                    merged[k] = v
                end
            end
            return merged
        end
    end

    local groups = {
        -- Comments
        Comment = safe_style_merge({ fg = c.comment }, config.styles.comments),
        
        -- Constants
        Constant = { fg = c.yellow3 },
        String = safe_style_merge({ fg = c.pink }, config.styles.strings or {}),
        Character = { fg = c.pink },
        Number = safe_style_merge({ fg = c.yellow3 }, config.styles.numbers or {}),
        Boolean = safe_style_merge({ fg = c.blue4 }, config.styles.booleans or {}),
        Float = { fg = c.yellow3 },
        
        -- Identifiers
        Identifier = { fg = c.editor_fg },
        Function = safe_style_merge({ fg = c.yellow2 }, config.styles.functions or {}),
        
        -- Statements
        Statement = { fg = c.blue4 },
        Conditional = { fg = c.blue4 },
        Repeat = { fg = c.blue4 },
        Label = { fg = c.blue4 },
        Operator = safe_style_merge({ fg = c.editor_fg }, config.styles.operators or {}),
        Keyword = safe_style_merge({ fg = c.blue4 }, config.styles.keywords or {}),
        Exception = { fg = c.blue4 },
        
        -- Preproc
        PreProc = { fg = c.green2 },
        Include = { fg = c.purple2 },
        Define = { fg = c.green2 },
        Macro = { fg = c.green2 },
        PreCondit = { fg = c.green2 },
        
        -- Types
        Type = safe_style_merge({ fg = c.blue3 }, config.styles.types or {}),
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
        Parameter = safe_style_merge({ fg = c.yellow4 }, config.styles.parameters or {}),
        Property = { fg = c.purple3 },
        Field = { fg = c.purple3 },
        Method = safe_style_merge({ fg = c.yellow2 }, config.styles.functions or {}),
        Constructor = { fg = c.yellow2 },
        Namespace = { fg = c.editor_fg },
        Annotation = { fg = c.green2 },
        Decorator = { fg = c.green2 },
        
        -- Expanded semantic highlighting (LSP semantic tokens)
        -- General semantic tokens
        ["@lsp.type.enumMember"] = { fg = c.gray8 }, -- "#d6d6dd" -> closest match gray8
        ["@lsp.type.variable.constant"] = { fg = c.blue4 }, -- "#83d6c5" -> blue4 "#82d2ce"
        ["@lsp.type.variable.defaultLibrary"] = { fg = c.gray8 }, -- "#d6d6dd" -> gray8
        ["@lsp.type.variable.defaultLibrary.globalScope"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.class.typeHint"] = { fg = c.blue4 }, -- "#82d2ce" -> blue4
        ["@lsp.type.function.builtin"] = { fg = c.blue4 }, -- "#82d2ce" -> blue4
        ["@lsp.type.class.builtin"] = { fg = c.blue4 }, -- "#82d2ce" -> blue4
        ["@lsp.type.selfParameter"] = { fg = c.red4 }, -- "#cc7c8a" -> red4
        ["@lsp.type.macro"] = { fg = c.green2 }, -- "#a8cc7c" -> green2
        
        -- Function and method declarations with configurable bold styling
        ["@lsp.type.method.declaration"] = safe_style_merge({ fg = c.yellow2 }, config.styles.method_declarations or {}), -- "#efb080" -> yellow2
        ["@lsp.type.function.declaration"] = safe_style_merge({ fg = c.yellow2 }, config.styles.function_declarations or {}), -- "#efb080" -> yellow2
        ["@entity.name.function"] = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}), -- "#E3C893" -> yellow3 "#ebc88d"
        ["@lsp.type.function"] = safe_style_merge({ fg = c.yellow3 }, config.styles.functions or {}), -- "#ebc88d" -> yellow3
        
        -- C/C++ language-specific semantic tokens
        ["@lsp.type.variable.declaration.readonly.cpp"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.variable.declaration.readonly.c"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.variable.readonly.cpp"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.variable.readonly.c"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.operatorOverload"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.memberOperatorOverload"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        ["@lsp.type.namespace.cpp"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        ["@lsp.type.variable.global.cpp"] = { fg = c.green2 }, -- "#a8cc7c" -> green2
        ["@lsp.type.variable.global.c"] = { fg = c.green2 }, -- "#a8cc7c" -> green2
        ["@lsp.type.type.cpp"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        ["@lsp.type.type.c"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        ["@lsp.type.function.cpp"] = safe_style_merge({ fg = "#efefef" }, config.styles.cpp_functions or {}), -- exact match
        ["@lsp.type.function.c"] = safe_style_merge({ fg = "#efefef" }, config.styles.c_functions or {}), -- exact match
        ["@lsp.type.method.cpp"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        ["@lsp.type.property.cpp"] = { fg = c.purple4 }, -- "#af9cff" -> purple4
        ["@lsp.type.property.declaration.cpp"] = { fg = c.purple4 }, -- "#af9cff" -> purple4
        ["@lsp.type.property.declaration.c"] = { fg = c.purple4 }, -- "#af9cff" -> purple4
        ["@lsp.type.property.c"] = { fg = c.purple4 }, -- "#af9cff" -> purple4
        
        -- Python language-specific semantic tokens
        ["@lsp.type.class.declaration.python"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        ["@lsp.type.class.decorator.builtin.python"] = { fg = c.green2 }, -- "#a8cc7c" -> green2
        ["@lsp.type.class.python"] = { fg = c.yellow3 }, -- "#ebc88d" -> yellow3
        ["@lsp.type.decorator.python"] = { fg = c.green2 }, -- "#a8cc7c" -> green2
        ["@lsp.type.method.python"] = { fg = c.yellow3 }, -- "#ebc88d" -> yellow3
        ["@lsp.type.builtinConstant.readonly.builtin.python"] = { fg = c.blue4 }, -- "#82d2ce" -> blue4
        
        -- TypeScript/JavaScript language-specific semantic tokens
        ["@lsp.type.variable.other.property.ts"] = { fg = c.purple3 }, -- "#AA9BF5" -> purple3
        ["@lsp.type.variable.other.property"] = { fg = c.purple3 }, -- "#AA9BF5" -> purple3
        ["@lsp.type.variable.other"] = { fg = c.purple3 }, -- "#AA9BF5" -> purple3
        ["@lsp.type.meta.definition.property.ts"] = safe_style_merge({ fg = c.purple3 }, config.styles.typescript_properties or {}), -- "#AA9BF5" -> purple3
        ["@lsp.type.support.variable.property"] = { fg = c.purple3 }, -- "#AA9BF5" -> purple3
        ["@lsp.type.variable.javascript"] = { fg = c.gray7 }, -- "#d1d1d1" -> gray7
        
        -- Other language semantic tokens
        ["@lsp.type.function.cmake"] = { fg = c.blue3 }, -- "#87c3ff" -> blue3
        
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
        cppFunction = safe_style_merge({ fg = "#efefef" }, config.styles.cpp_functions or {}),
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
        
        -- Enhanced italic styling patterns to match VS Code
        -- JavaScript/TypeScript attributes and parameters
        jsObjectProp = safe_style_merge({ fg = c.purple3 }, config.styles.js_attributes or {}),
        jsObjectKey = safe_style_merge({ fg = c.purple3 }, config.styles.js_attributes or {}),
        tsObjectPropertyName = safe_style_merge({ fg = c.purple3 }, config.styles.js_attributes or {}),
        tsParameter = safe_style_merge({ fg = c.yellow4 }, config.styles.js_attributes or {}),
        
        -- Python control flow keywords with italic
        pythonConditional = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        pythonRepeat = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        pythonImport = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        pythonException = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        
        -- Markdown italic text
        markdownItalic = safe_style_merge({ fg = c.editor_fg }, config.styles.markdown_italic or {}),
        markdownItalicDelimiter = safe_style_merge({ fg = c.editor_fg }, config.styles.markdown_italic or {}),
        
        -- Additional function declaration patterns
        cFunction = safe_style_merge({ fg = "#efefef" }, config.styles.c_functions or {}),
        luaFunction = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        rustFunction = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        goFunc = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
    }
    
    return groups
end

return M
