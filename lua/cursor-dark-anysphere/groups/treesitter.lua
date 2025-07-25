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
        -- Identifiers
        ["@variable"] = { fg = c.editor_fg },
        ["@variable.builtin"] = { fg = c.red5 },
        ["@variable.parameter"] = safe_style_merge({ fg = c.editor_fg }, config.styles.parameters),
        ["@variable.parameter.builtin"] = safe_style_merge({ fg = c.editor_fg }, config.styles.parameters or {}),
        ["@variable.member"] = { fg = c.purple3 },
        
        -- Constants
        ["@constant"] = { fg = c.yellow2 },
        ["@constant.builtin"] = { fg = c.blue4 },
        ["@constant.macro"] = { fg = c.green2 },
        
        -- Literals
        ["@string"] = safe_style_merge({ fg = c.pink }, config.styles.strings or {}),
        ["@string.documentation"] = { fg = c.pink },
        ["@string.regex"] = { fg = c.editor_fg },
        ["@string.escape"] = { fg = c.editor_fg },
        ["@string.special"] = { fg = c.editor_fg },
        ["@string.special.symbol"] = { fg = c.editor_fg },
        ["@string.special.path"] = { fg = c.pink },
        ["@string.special.url"] = { fg = c.blue1, underline = true },
        
        ["@character"] = { fg = c.pink },
        ["@character.special"] = { fg = c.editor_fg },
        
        ["@boolean"] = safe_style_merge({ fg = c.blue4 }, config.styles.booleans or {}),
        ["@number"] = safe_style_merge({ fg = c.yellow3 }, config.styles.numbers or {}),
        ["@number.float"] = { fg = c.yellow3 },
        
        -- Functions with enhanced styling
        ["@function"] = safe_style_merge({ fg = c.yellow3 }, config.styles.functions or {}),
        ["@function.builtin"] = { fg = c.blue4 },
        ["@function.call"] = { fg = c.yellow3 },
        ["@function.macro"] = { fg = c.green2 },
        ["@function.method"] = safe_style_merge({ fg = c.yellow3 }, config.styles.functions or {}),
        ["@function.method.call"] = { fg = c.yellow3 },
        
        -- Function and method declarations
        ["@function.declaration"] = safe_style_merge({ fg = c.yellow2 }, config.styles.function_declarations or {}),
        ["@method.declaration"] = safe_style_merge({ fg = c.yellow2 }, config.styles.method_declarations or {}),
        
        ["@constructor"] = { fg = c.yellow2 },
        ["@operator"] = safe_style_merge({ fg = c.editor_fg }, config.styles.operators or {}),
        
        -- Keywords
        ["@keyword"] = safe_style_merge({ fg = c.blue4 }, config.styles.keywords or {}),
        ["@keyword.coroutine"] = { fg = c.blue4 },
        ["@keyword.function"] = { fg = c.blue4 },
        ["@keyword.operator"] = { fg = c.blue4 },
        ["@keyword.import"] = safe_style_merge({ fg = c.blue4 }, config.styles.keywords or {}),
        ["@keyword.type"] = { fg = c.blue4 },
        ["@keyword.modifier"] = { fg = c.blue4 },
        ["@keyword.repeat"] = { fg = c.blue4 },
        ["@keyword.return"] = { fg = c.blue4 },
        ["@keyword.debug"] = { fg = c.blue4 },
        ["@keyword.exception"] = { fg = c.blue4 },
        ["@keyword.conditional"] = { fg = c.blue4 },
        ["@keyword.conditional.ternary"] = { fg = c.blue4 },
        ["@keyword.directive"] = { fg = c.green2 },
        ["@keyword.directive.define"] = { fg = c.green2 },
        
        -- Punctuation
        ["@punctuation.delimiter"] = { fg = c.editor_fg },
        ["@punctuation.bracket"] = { fg = c.editor_fg },
        ["@punctuation.special"] = { fg = c.blue4 },
        
        -- Comments
        ["@comment"] = safe_style_merge({ fg = c.comment }, config.styles.comments or {}),
        ["@comment.documentation"] = safe_style_merge({ fg = c.comment }, config.styles.comments or {}),
        ["@comment.error"] = { fg = c.red1 },
        ["@comment.warning"] = { fg = c.yellow1 },
        ["@comment.todo"] = { fg = c.yellow1, bold = true },
        ["@comment.note"] = { fg = c.blue2, bold = true },
        
        -- Markup
        ["@markup"] = { fg = c.editor_fg },
        ["@markup.strong"] = { fg = c.yellow4, bold = true },
        ["@markup.italic"] = { fg = c.blue4, italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },
        
        ["@markup.heading"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.1"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.2"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.3"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.4"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.5"] = { fg = c.editor_fg, bold = true },
        ["@markup.heading.6"] = { fg = c.editor_fg, bold = true },
        
        ["@markup.quote"] = { fg = c.comment },
        ["@markup.math"] = { fg = c.editor_fg },
        
        ["@markup.link"] = { fg = c.blue4 },
        ["@markup.link.label"] = { fg = c.purple2 },
        ["@markup.link.url"] = { fg = c.blue4, underline = true },
        
        ["@markup.raw"] = { fg = c.pink },
        ["@markup.raw.block"] = { fg = c.pink },
        
        ["@markup.list"] = { fg = c.editor_fg },
        ["@markup.list.checked"] = { fg = c.green1 },
        ["@markup.list.unchecked"] = { fg = c.editor_fg },
        
        -- Tags
        ["@tag"] = { fg = c.gray6 },
        ["@tag.attribute"] = { fg = c.purple2 },
        ["@tag.delimiter"] = { fg = c.gray6 },
        
        -- Types
        ["@type"] = safe_style_merge({ fg = c.blue3 }, config.styles.types or {}),
        ["@type.builtin"] = { fg = c.blue4 },
        ["@type.definition"] = { fg = c.blue3 },
        ["@type.qualifier"] = { fg = c.blue4 },
        
        -- Namespaces
        ["@module"] = { fg = c.editor_fg },
        ["@module.builtin"] = { fg = c.yellow2 },
        ["@label"] = { fg = c.blue4 },
        
        -- Attributes
        ["@attribute"] = { fg = c.green2 },
        ["@attribute.builtin"] = { fg = c.green2 },
        ["@property"] = { fg = c.purple3 },
        
        -- Diff
        ["@diff.plus"] = { fg = c.green1 },
        ["@diff.minus"] = { fg = c.red1 },
        ["@diff.delta"] = { fg = c.yellow1 },
        
        -- Language specific overrides based on VSCode semanticTokenColors
        
        -- Python
        ["@type.python"] = { fg = c.yellow3 },
        ["@constructor.python"] = { fg = c.yellow3 },
        ["@function.decorator.python"] = safe_style_merge({ fg = c.green2 }, config.styles.functions or {}),
        ["@variable.parameter.python"] = safe_style_merge({ fg = c.yellow4 }, config.styles.parameters or {}),
        ["@variable.builtin.python"] = { fg = c.yellow2 },
        
        -- JavaScript/TypeScript
        ["@variable.member.typescript"] = { fg = c.purple3 },
        ["@variable.member.javascript"] = { fg = c.purple3 },
        ["@type.builtin.typescript"] = { fg = c.blue4 },
        ["@punctuation.special.typescript"] = { fg = c.blue4 },
        ["@keyword.operator.typescript"] = { fg = c.blue4 },
        
        -- C/C++
        ["@type.c"] = { fg = c.blue3 },
        ["@type.cpp"] = { fg = c.blue3 },
        ["@function.c"] = safe_style_merge({ fg = "#efefef" }, config.styles.c_functions or {}),
        ["@function.cpp"] = safe_style_merge({ fg = "#efefef" }, config.styles.cpp_functions or {}),
        ["@method.cpp"] = { fg = c.blue3 },
        ["@variable.builtin.cpp"] = { fg = c.blue4 },
        ["@namespace.cpp"] = { fg = c.blue3 },
        ["@constant.macro.c"] = { fg = c.green2 },
        ["@constant.macro.cpp"] = { fg = c.green2 },
        
        -- Rust
        ["@function.macro.rust"] = { fg = c.green2 },
        ["@type.rust"] = { fg = c.blue3 },
        ["@variable.builtin.rust"] = { fg = c.editor_fg },
        ["@module.rust"] = { fg = c.blue3 },
        ["@punctuation.special.rust"] = { fg = c.blue4 },
        
        -- Go
        ["@function.go"] = { fg = c.yellow3 },
        ["@function.method.go"] = { fg = c.yellow3 },
        ["@module.go"] = { fg = c.yellow2 },
        
        -- HTML
        ["@tag.html"] = { fg = c.blue3 },
        ["@tag.attribute.html"] = { fg = c.purple2 },
        ["@string.special.url.html"] = { fg = c.pink },
        
        -- CSS
        ["@type.css"] = { fg = c.yellow4 },
        ["@property.css"] = { fg = c.blue3 },
        ["@string.css"] = { fg = c.pink },
        
        -- JSON
        ["@label.json"] = { fg = c.blue4 },
        ["@property.json"] = { fg = c.blue4 },
        
        -- Regex patterns
        ["@string.regexp"] = { fg = c.editor_fg },
        ["@operator.regex"] = { fg = c.yellow4 },
        ["@punctuation.bracket.regex"] = { fg = c.editor_fg },
        ["@constant.character.escape.regex"] = { fg = c.editor_fg },
        
        -- Enhanced treesitter patterns for VS Code font styling
        -- JavaScript/TypeScript enhanced patterns
        ["@property.javascript"] = safe_style_merge({ fg = c.purple3 }, config.styles.js_attributes or {}),
        ["@property.typescript"] = safe_style_merge({ fg = c.purple3 }, config.styles.js_attributes or {}),
        ["@variable.parameter.javascript"] = safe_style_merge({ fg = c.yellow4 }, config.styles.js_attributes or {}),
        ["@variable.parameter.typescript"] = safe_style_merge({ fg = c.yellow4 }, config.styles.js_attributes or {}),
        
        -- Python enhanced keyword patterns
        ["@keyword.control.python"] = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        ["@keyword.import.python"] = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        ["@keyword.conditional.python"] = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        ["@keyword.repeat.python"] = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        ["@keyword.exception.python"] = safe_style_merge({ fg = c.blue4 }, config.styles.python_keywords or {}),
        
        -- Enhanced function declaration patterns for various languages
        ["@function.declaration.python"] = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        ["@function.declaration.javascript"] = safe_style_merge({ fg = c.yellow2 }, config.styles.function_declarations or {}),
        ["@function.declaration.typescript"] = safe_style_merge({ fg = c.yellow2 }, config.styles.function_declarations or {}),
        ["@function.declaration.rust"] = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        ["@function.declaration.go"] = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        ["@function.declaration.lua"] = safe_style_merge({ fg = c.yellow3 }, config.styles.function_declarations or {}),
        
        -- Method declaration patterns
        ["@method.declaration.python"] = safe_style_merge({ fg = c.yellow3 }, config.styles.method_declarations or {}),
        ["@method.declaration.javascript"] = safe_style_merge({ fg = c.yellow2 }, config.styles.method_declarations or {}),
        ["@method.declaration.typescript"] = safe_style_merge({ fg = c.yellow2 }, config.styles.method_declarations or {}),
        ["@method.declaration.cpp"] = safe_style_merge({ fg = c.blue3 }, config.styles.method_declarations or {}),
        ["@method.declaration.c"] = safe_style_merge({ fg = "#efefef" }, config.styles.method_declarations or {}),
        
        -- TypeScript property declarations
        ["@property.declaration.typescript"] = safe_style_merge({ fg = c.purple3 }, config.styles.typescript_properties or {}),
        
        -- Enhanced C/C++ function patterns
        ["@function.declaration.c"] = safe_style_merge({ fg = "#efefef" }, config.styles.c_functions or {}),
        ["@function.declaration.cpp"] = safe_style_merge({ fg = "#efefef" }, config.styles.cpp_functions or {}),
    }
    
    -- Legacy treesitter highlights (for compatibility)
    groups["TSAnnotation"] = groups["@attribute"]
    groups["TSAttribute"] = groups["@attribute"]
    groups["TSBoolean"] = groups["@boolean"]
    groups["TSCharacter"] = groups["@character"]
    groups["TSCharacterSpecial"] = groups["@character.special"]
    groups["TSComment"] = groups["@comment"]
    groups["TSConditional"] = groups["@keyword.conditional"]
    groups["TSConstant"] = groups["@constant"]
    groups["TSConstBuiltin"] = groups["@constant.builtin"]
    groups["TSConstMacro"] = groups["@constant.macro"]
    groups["TSConstructor"] = groups["@constructor"]
    groups["TSDebug"] = groups["@keyword.debug"]
    groups["TSDefine"] = groups["@keyword.directive.define"]
    groups["TSError"] = { fg = c.red1 }
    groups["TSException"] = groups["@keyword.exception"]
    groups["TSField"] = groups["@variable.member"]
    groups["TSFloat"] = groups["@number.float"]
    groups["TSFunction"] = groups["@function"]
    groups["TSFuncBuiltin"] = groups["@function.builtin"]
    groups["TSFuncMacro"] = groups["@function.macro"]
    groups["TSInclude"] = groups["@keyword.import"]
    groups["TSKeyword"] = groups["@keyword"]
    groups["TSKeywordFunction"] = groups["@keyword.function"]
    groups["TSKeywordOperator"] = groups["@keyword.operator"]
    groups["TSKeywordReturn"] = groups["@keyword.return"]
    groups["TSLabel"] = groups["@label"]
    groups["TSMethod"] = groups["@function.method"]
    groups["TSNamespace"] = groups["@module"]
    groups["TSNone"] = { fg = c.editor_fg }
    groups["TSNumber"] = groups["@number"]
    groups["TSOperator"] = groups["@operator"]
    groups["TSParameter"] = groups["@variable.parameter"]
    groups["TSParameterReference"] = groups["@variable.parameter"]
    groups["TSPreProc"] = groups["@keyword.directive"]
    groups["TSProperty"] = groups["@property"]
    groups["TSPunctDelimiter"] = groups["@punctuation.delimiter"]
    groups["TSPunctBracket"] = groups["@punctuation.bracket"]
    groups["TSPunctSpecial"] = groups["@punctuation.special"]
    groups["TSRepeat"] = groups["@keyword.repeat"]
    groups["TSStorageClass"] = groups["@type.qualifier"]
    groups["TSString"] = groups["@string"]
    groups["TSStringRegex"] = groups["@string.regexp"]
    groups["TSStringEscape"] = groups["@string.escape"]
    groups["TSStringSpecial"] = groups["@string.special"]
    groups["TSSymbol"] = groups["@string.special.symbol"]
    groups["TSTag"] = groups["@tag"]
    groups["TSTagAttribute"] = groups["@tag.attribute"]
    groups["TSTagDelimiter"] = groups["@tag.delimiter"]
    groups["TSText"] = groups["@markup"]
    groups["TSStrong"] = groups["@markup.strong"]
    groups["TSEmphasis"] = groups["@markup.italic"]
    groups["TSUnderline"] = groups["@markup.underline"]
    groups["TSStrike"] = groups["@markup.strikethrough"]
    groups["TSTitle"] = groups["@markup.heading"]
    groups["TSLiteral"] = groups["@markup.raw"]
    groups["TSURI"] = groups["@markup.link.url"]
    groups["TSMath"] = groups["@markup.math"]
    groups["TSTextReference"] = groups["@markup.link"]
    groups["TSEnvironment"] = groups["@module"]
    groups["TSEnvironmentName"] = groups["@module"]
    groups["TSNote"] = groups["@comment.note"]
    groups["TSWarning"] = groups["@comment.warning"]
    groups["TSDanger"] = groups["@comment.error"]
    groups["TSType"] = groups["@type"]
    groups["TSTypeBuiltin"] = groups["@type.builtin"]
    groups["TSTypeQualifier"] = groups["@type.qualifier"]
    groups["TSTypeDefinition"] = groups["@type.definition"]
    groups["TSVariable"] = groups["@variable"]
    groups["TSVariableBuiltin"] = groups["@variable.builtin"]
    
    return groups
end

return M
