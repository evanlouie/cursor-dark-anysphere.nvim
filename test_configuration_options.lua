#!/usr/bin/env lua

-- Configuration Validation Test for cursor-dark-anysphere theme
-- Tests all configuration options, validation, and edge cases
-- Run with: lua test_configuration_options.lua

print("Cursor Dark Anysphere - Configuration Validation Test")
print("===================================================")

-- Mock vim environment for testing
_G.vim = {
    notify = function(msg, level) 
        print("NOTIFY [" .. (level or "INFO") .. "]: " .. msg) 
    end,
    log = { levels = { WARN = "WARN", ERROR = "ERROR", INFO = "INFO" } },
    deepcopy = function(t)
        if type(t) ~= "table" then return t end
        local copy = {}
        for k, v in pairs(t) do
            copy[k] = vim.deepcopy(v)
        end
        return copy
    end,
    tbl_deep_extend = function(mode, base, ...)
        local result = vim.deepcopy(base)
        for _, overlay in ipairs({...}) do
            for k, v in pairs(overlay) do
                if type(v) == "table" and type(result[k]) == "table" then
                    result[k] = vim.tbl_deep_extend(mode, result[k], v)
                else
                    result[k] = v
                end
            end
        end
        return result
    end
}

-- Add the lua directory to package path
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

-- Load configuration module
local config = require('cursor-dark-anysphere.config')

local test_results = {
    total = 0,
    passed = 0,
    failed = 0
}

local function run_test(description, test_func)
    test_results.total = test_results.total + 1
    local success, result = pcall(test_func)
    
    if success and result then
        print("   ✓ " .. description)
        test_results.passed = test_results.passed + 1
        return true
    else
        print("   ✗ " .. description .. (result and (" - " .. tostring(result)) or ""))
        test_results.failed = test_results.failed + 1
        return false
    end
end

local function test_section(title)
    print("\n" .. title .. ":")
end

-- Test 1: Default Configuration Structure
test_section("1. Default Configuration Structure Tests")

run_test("Default config has all required top-level keys", function()
    local default = config.default_config
    return default.style and
           default.transparent ~= nil and
           default.transparency_mode and
           default.ending_tildes ~= nil and
           default.cmp_itemkind_reverse ~= nil and
           default.transparencies and
           default.styles and
           default.colors and
           default.highlights and
           default.plugins
end)

run_test("Default transparency settings are properly structured", function()
    local transparencies = config.default_config.transparencies
    return transparencies.floats ~= nil and
           transparencies.popups ~= nil and
           transparencies.sidebar ~= nil and
           transparencies.statusline ~= nil and
           type(transparencies.floats) == "boolean"
end)

run_test("Default styles contain all enhanced font styling options", function()
    local styles = config.default_config.styles
    return styles.comments and
           styles.keywords and
           styles.functions and
           styles.variables and
           styles.parameters and
           -- New enhanced options
           styles.function_declarations and
           styles.method_declarations and
           styles.cpp_functions and
           styles.c_functions and
           styles.typescript_properties and
           styles.js_attributes and
           styles.python_keywords and
           styles.markdown_italic
end)

run_test("Default plugin configuration includes all supported plugins", function()
    local plugins = config.default_config.plugins
    return plugins.telescope and
           plugins.nvim_tree and
           plugins.neo_tree and
           plugins.nvim_cmp and
           plugins.lualine and
           plugins.gitsigns and
           plugins.treesitter and
           plugins.indent_blankline and
           plugins.dashboard and
           plugins.which_key and
           plugins.trouble and
           plugins.todo_comments and
           plugins.lazy and
           plugins.mini and
           plugins.snacks and
           -- New plugin integrations
           plugins.dap and
           plugins.copilot and
           plugins.oil and
           plugins.conform and
           plugins.noice
end)

-- Test 2: Configuration Setup and Merging
test_section("2. Configuration Setup and Merging Tests")

run_test("Empty setup preserves default configuration", function()
    config.setup({})
    local cfg = config.get()
    local default = config.default_config
    
    return cfg.style == default.style and
           cfg.transparent == default.transparent and
           cfg.transparency_mode == default.transparency_mode
end)

run_test("Simple option override works correctly", function()
    config.setup({
        transparent = true,
        ending_tildes = true
    })
    local cfg = config.get()
    
    return cfg.transparent == true and
           cfg.ending_tildes == true and
           cfg.style == config.default_config.style -- unchanged
end)

run_test("Nested option override works correctly", function()
    config.setup({
        transparencies = {
            floats = false,
            sidebar = true
        },
        styles = {
            comments = { italic = false, bold = true },
            functions = { underline = true }
        }
    })
    local cfg = config.get()
    
    return cfg.transparencies.floats == false and
           cfg.transparencies.sidebar == true and
           cfg.transparencies.popups == config.default_config.transparencies.popups and -- unchanged
           cfg.styles.comments.italic == false and
           cfg.styles.comments.bold == true and
           cfg.styles.functions.underline == true
end)

run_test("Plugin configuration override works correctly", function()
    config.setup({
        plugins = {
            telescope = false,
            dap = false,
            noice = false
        }
    })
    local cfg = config.get()
    
    return cfg.plugins.telescope == false and
           cfg.plugins.dap == false and
           cfg.plugins.noice == false and
           cfg.plugins.nvim_tree == config.default_config.plugins.nvim_tree -- unchanged
end)

-- Test 3: Transparency Mode Validation
test_section("3. Transparency Mode Validation Tests")

run_test("Valid transparency modes are accepted", function()
    local valid_modes = {'blended', 'transparent', 'opaque'}
    
    for _, mode in ipairs(valid_modes) do
        config.setup({ transparency_mode = mode })
        local cfg = config.get()
        if cfg.transparency_mode ~= mode then
            return false
        end
    end
    return true
end)

run_test("Invalid transparency mode triggers validation warning", function()
    local notification_received = false
    local original_notify = vim.notify
    
    vim.notify = function(msg, level)
        if msg:match("Invalid transparency_mode") and level == vim.log.levels.WARN then
            notification_received = true
        end
    end
    
    config.setup({ transparency_mode = 'invalid_mode' })
    local cfg = config.get()
    
    vim.notify = original_notify
    
    return notification_received and cfg.transparency_mode == 'blended'
end)

run_test("Transparent flag overrides transparency_mode", function()
    config.setup({
        transparent = true,
        transparency_mode = 'opaque'
    })
    local cfg = config.get()
    
    return cfg.transparent == true and cfg.transparency_mode == 'transparent'
end)

-- Test 4: Font Styling Configuration Tests  
test_section("4. Font Styling Configuration Tests")

run_test("All enhanced font styling options can be configured", function()
    config.setup({
        styles = {
            function_declarations = { bold = true, italic = false },
            method_declarations = { bold = false, italic = true },
            cpp_functions = { bold = true, underline = true },
            c_functions = { bold = false },
            typescript_properties = { italic = true, bold = true },
            js_attributes = { italic = false },
            python_keywords = { italic = true },
            markdown_italic = { italic = false }
        }
    })
    local cfg = config.get()
    
    return cfg.styles.function_declarations.bold == true and
           cfg.styles.function_declarations.italic == false and
           cfg.styles.method_declarations.bold == false and
           cfg.styles.method_declarations.italic == true and
           cfg.styles.cpp_functions.bold == true and
           cfg.styles.cpp_functions.underline == true and
           cfg.styles.c_functions.bold == false and
           cfg.styles.typescript_properties.italic == true and
           cfg.styles.typescript_properties.bold == true and
           cfg.styles.js_attributes.italic == false and
           cfg.styles.python_keywords.italic == true and
           cfg.styles.markdown_italic.italic == false
end)

run_test("Traditional styling options still work", function()
    config.setup({
        styles = {
            comments = { italic = true, bold = false },
            keywords = { italic = false, bold = true },
            functions = { bold = true },
            variables = { italic = true },
            operators = { bold = false },
            booleans = { italic = true },
            strings = { underline = true },
            types = { bold = true, italic = false },
            numbers = { strikethrough = true },
            parameters = { italic = false, bold = true }
        }
    })
    local cfg = config.get()
    
    return cfg.styles.comments.italic == true and
           cfg.styles.comments.bold == false and
           cfg.styles.keywords.italic == false and
           cfg.styles.keywords.bold == true and
           cfg.styles.functions.bold == true and
           cfg.styles.variables.italic == true and
           cfg.styles.operators.bold == false and
           cfg.styles.booleans.italic == true and
           cfg.styles.strings.underline == true and
           cfg.styles.types.bold == true and
           cfg.styles.types.italic == false and
           cfg.styles.numbers.strikethrough == true and
           cfg.styles.parameters.italic == false and
           cfg.styles.parameters.bold == true
end)

-- Test 5: New Plugin Configuration Tests
test_section("5. New Plugin Configuration Tests")

run_test("All new plugins can be individually disabled", function()
    config.setup({
        plugins = {
            dap = false,
            copilot = false,
            oil = false,
            conform = false,
            noice = false
        }
    })
    local cfg = config.get()
    
    return cfg.plugins.dap == false and
           cfg.plugins.copilot == false and
           cfg.plugins.oil == false and
           cfg.plugins.conform == false and
           cfg.plugins.noice == false
end)

run_test("Plugin configuration preserves existing plugins", function()
    config.setup({
        plugins = {
            dap = false,
            oil = false
        }
    })
    local cfg = config.get()
    
    return cfg.plugins.dap == false and
           cfg.plugins.oil == false and
           cfg.plugins.telescope == config.default_config.plugins.telescope and
           cfg.plugins.nvim_tree == config.default_config.plugins.nvim_tree and
           cfg.plugins.lualine == config.default_config.plugins.lualine
end)

-- Test 6: Color and Highlight Override Tests
test_section("6. Color and Highlight Override Tests")

run_test("Custom colors can be specified", function()
    config.setup({
        colors = {
            editor_bg = "#000000",
            editor_fg = "#FFFFFF",
            custom_color = "#FF0000"
        }
    })
    local cfg = config.get()
    
    return cfg.colors.editor_bg == "#000000" and
           cfg.colors.editor_fg == "#FFFFFF" and
           cfg.colors.custom_color == "#FF0000"
end)

run_test("Custom highlights can be specified", function()
    config.setup({
        highlights = {
            Normal = { fg = "#FFFFFF", bg = "#000000" },
            Comment = { fg = "#808080", italic = true },
            CustomGroup = { fg = "#FF0000", bold = true }
        }
    })
    local cfg = config.get()
    
    return cfg.highlights.Normal and
           cfg.highlights.Normal.fg == "#FFFFFF" and
           cfg.highlights.Normal.bg == "#000000" and
           cfg.highlights.Comment and
           cfg.highlights.Comment.fg == "#808080" and
           cfg.highlights.Comment.italic == true and
           cfg.highlights.CustomGroup and
           cfg.highlights.CustomGroup.fg == "#FF0000" and
           cfg.highlights.CustomGroup.bold == true
end)

-- Test 7: Edge Cases and Error Handling
test_section("7. Edge Cases and Error Handling Tests")

run_test("Configuration handles nil input gracefully", function()
    config.setup(nil)
    local cfg = config.get()
    
    return cfg.style == config.default_config.style and
           cfg.transparent == config.default_config.transparent
end)

run_test("Configuration handles empty table gracefully", function()
    config.setup({})
    local cfg = config.get()
    
    return cfg.style == config.default_config.style and
           cfg.transparent == config.default_config.transparent
end)

run_test("Configuration handles partial nested structures", function()
    config.setup({
        transparencies = {
            floats = true
            -- Missing other transparency options
        },
        styles = {
            comments = { italic = true }
            -- Missing other style options
        }
    })
    local cfg = config.get()
    
    return cfg.transparencies.floats == true and
           cfg.transparencies.popups == config.default_config.transparencies.popups and
           cfg.styles.comments.italic == true and
           cfg.styles.functions == config.default_config.styles.functions
end)

run_test("Multiple configuration calls work correctly", function()
    -- First setup
    config.setup({ transparent = true })
    local cfg1 = config.get()
    
    -- Second setup should override
    config.setup({ transparent = false, ending_tildes = true })
    local cfg2 = config.get()
    
    return cfg1.transparent == true and
           cfg2.transparent == false and
           cfg2.ending_tildes == true
end)

-- Test 8: Configuration State Management
test_section("8. Configuration State Management Tests")

run_test("Configuration preserves state between get() calls", function()
    config.setup({
        transparent = true,
        styles = { comments = { italic = true, bold = true } }
    })
    
    local cfg1 = config.get()
    local cfg2 = config.get()
    
    return cfg1.transparent == cfg2.transparent and
           cfg1.styles.comments.italic == cfg2.styles.comments.italic and
           cfg1.styles.comments.bold == cfg2.styles.comments.bold
end)

run_test("Configuration is independent of default_config modifications", function()
    local original_transparent = config.default_config.transparent
    
    config.setup({ transparent = true })
    local cfg = config.get()
    
    -- Modify default_config (should not affect current config)
    config.default_config.transparent = false
    local cfg_after = config.get()
    
    -- Restore default
    config.default_config.transparent = original_transparent
    
    return cfg.transparent == true and cfg_after.transparent == true
end)

-- Test 9: Complex Configuration Scenarios
test_section("9. Complex Configuration Scenarios Tests")

run_test("Complete custom configuration works", function()
    config.setup({
        style = 'dark',
        transparent = false,
        transparency_mode = 'blended',
        ending_tildes = true,
        cmp_itemkind_reverse = true,
        transparencies = {
            floats = true,
            popups = false,
            sidebar = true,
            statusline = false
        },
        styles = {
            comments = { italic = true, bold = false },
            keywords = { italic = false, bold = true },
            functions = { bold = true },
            function_declarations = { bold = true, italic = true },
            method_declarations = { bold = false, italic = true },
            cpp_functions = { bold = true },
            typescript_properties = { italic = true }
        },
        colors = {
            editor_bg = "#1e1e1e",
            custom_accent = "#00FF00"
        },
        highlights = {
            CustomHighlight = { fg = "#FF0000", bold = true }
        },
        plugins = {
            telescope = true,
            dap = true,
            copilot = false,
            oil = true,
            noice = false
        }
    })
    
    local cfg = config.get()
    
    return cfg.style == 'dark' and
           cfg.transparent == false and
           cfg.transparency_mode == 'blended' and
           cfg.ending_tildes == true and
           cfg.cmp_itemkind_reverse == true and
           cfg.transparencies.floats == true and
           cfg.transparencies.popups == false and
           cfg.styles.comments.italic == true and
           cfg.styles.function_declarations.bold == true and
           cfg.styles.function_declarations.italic == true and
           cfg.colors.editor_bg == "#1e1e1e" and
           cfg.colors.custom_accent == "#00FF00" and
           cfg.highlights.CustomHighlight.fg == "#FF0000" and
           cfg.plugins.telescope == true and
           cfg.plugins.dap == true and
           cfg.plugins.copilot == false and
           cfg.plugins.oil == true and
           cfg.plugins.noice == false
end)

-- Test Summary
test_section("Test Summary")

print(string.format("Total Tests: %d", test_results.total))
print(string.format("Passed: %d", test_results.passed))
print(string.format("Failed: %d", test_results.failed))
print(string.format("Success Rate: %.1f%%", (test_results.passed / test_results.total) * 100))

if test_results.failed == 0 then
    print("\n🎉 ALL CONFIGURATION TESTS PASSED!")
    print("✓ Default configuration is complete and well-structured")
    print("✓ Configuration merging works correctly") 
    print("✓ Transparency mode validation functions properly")
    print("✓ Enhanced font styling options are fully configurable")
    print("✓ New plugin configurations are properly integrated")
    print("✓ Color and highlight overrides work as expected")
    print("✓ Edge cases and error scenarios are handled gracefully")
    print("✓ Configuration state management is robust")
    print("✓ Complex configuration scenarios work correctly")
else
    print(string.format("\n⚠️  %d CONFIGURATION TESTS FAILED", test_results.failed))
    print("Configuration validation needs attention before deployment")
end

print("\n" .. string.rep("=", 60))
print("Configuration validation test completed.")
print(string.rep("=", 60))
