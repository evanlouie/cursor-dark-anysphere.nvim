#!/usr/bin/env lua

-- Comprehensive Integration Test for cursor-dark-anysphere theme
-- Tests theme loading, transparency modes, color processing, and error handling
-- Run with: lua test_theme_integration.lua

print("Cursor Dark Anysphere - Comprehensive Integration Test")
print("===================================================")

-- Mock vim environment for testing
_G.vim = {
    notify = function(msg, level) print("NOTIFY: " .. msg) end,
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
    end,
    g = {},
    o = {},
    api = {
        nvim_set_hl = function(ns, name, settings)
            -- Mock highlight setting
            return true
        end,
        nvim_create_autocmd = function(event, opts)
            -- Mock autocmd creation
            return 1
        end
    },
    cmd = function(cmd) 
        -- Mock vim commands
        return true
    end,
    fn = {
        exists = function(var) return 1 end,
        getcwd = function() return "/test/path" end
    }
}

-- Add the lua directory to package path
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

-- Test helper functions
local function assert_test(condition, message)
    if condition then
        print("   ✓ " .. message)
        return true
    else
        print("   ✗ " .. message)
        return false
    end
end

local function test_section(title)
    print("\n" .. title .. ":")
end

-- Load theme modules
local config = require('cursor-dark-anysphere.config')
local palette = require('cursor-dark-anysphere.palette')
local utils = require('cursor-dark-anysphere.utils')
local theme = require('cursor-dark-anysphere')

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

-- Test 1: Module Loading
test_section("1. Module Loading Tests")

run_test("Config module loads correctly", function()
    return config and config.setup and config.get
end)

run_test("Palette module loads correctly", function()
    return palette and palette.get_colors and palette.vscode_colors
end)

run_test("Utils module loads correctly", function()
    return utils and utils.process_color and utils.blend
end)

run_test("Main theme module loads correctly", function()
    return theme and theme.setup and theme.get_colors
end)

-- Test 2: Configuration System
test_section("2. Configuration System Tests")

run_test("Default configuration is valid", function()
    local default_cfg = config.default_config
    return default_cfg and 
           default_cfg.style and 
           default_cfg.transparency_mode and
           default_cfg.plugins and
           default_cfg.styles
end)

run_test("Configuration setup works with empty options", function()
    config.setup({})
    local cfg = config.get()
    return cfg and cfg.style == 'dark'
end)

run_test("Configuration setup works with custom options", function()
    config.setup({
        transparent = true,
        transparency_mode = 'transparent',
        styles = {
            comments = { italic = true, bold = true }
        }
    })
    local cfg = config.get()
    return cfg.transparent == true and 
           cfg.transparency_mode == 'transparent' and
           cfg.styles.comments.italic == true
end)

run_test("Invalid transparency mode triggers validation", function()
    local original_notify = vim.notify
    local validation_triggered = false
    
    vim.notify = function(msg, level)
        if msg:match("Invalid transparency_mode") then
            validation_triggered = true
        end
    end
    
    config.setup({ transparency_mode = 'invalid_mode' })
    vim.notify = original_notify
    
    local cfg = config.get()
    return validation_triggered and cfg.transparency_mode == 'blended'
end)

-- Test 3: Color Processing Pipeline
test_section("3. Color Processing Pipeline Tests")

run_test("VSCode colors are properly defined", function()
    local vscode_colors = palette.vscode_colors
    return vscode_colors.editor_bg and 
           vscode_colors.editor_fg and
           vscode_colors.blue1 and
           vscode_colors.red1 and
           #vscode_colors.editor_bg == 7 -- hex color length
end)

run_test("New colors from enhancements are present", function()
    local vscode_colors = palette.vscode_colors
    return vscode_colors.minimap_gutter_added_bg and
           vscode_colors.button_secondary_bg and
           vscode_colors.input_validation_error_fg and
           vscode_colors.extension_button_prominent_bg
end)

run_test("Color processing works in blended mode", function()
    local colors = palette.get_colors('blended')
    return colors.editor_bg and 
           colors.comment and
           colors.diff_added_bg and
           colors.selection_bg
end)

run_test("Color processing works in transparent mode", function()
    local colors = palette.get_colors('transparent')
    return colors.editor_bg and 
           colors.comment and
           not colors.comment:match("00$") -- should not have alpha
end)

run_test("Color processing works in opaque mode", function()
    local colors = palette.get_colors('opaque')
    return colors.editor_bg and 
           colors.comment and
           colors.diff_added_bg
end)

-- Test 4: Theme Setup and Integration
test_section("4. Theme Setup and Integration Tests")

run_test("Theme setup works with default configuration", function()
    theme.setup()
    return vim.g.colors_name == 'cursor-dark-anysphere'
end)

run_test("Theme setup works with transparent mode", function()
    theme.setup({ transparent = true })
    return vim.g.colors_name == 'cursor-dark-anysphere'
end)

run_test("Theme setup works with custom styles", function()
    theme.setup({
        styles = {
            functions = { bold = true },
            comments = { italic = true }
        }
    })
    return vim.g.colors_name == 'cursor-dark-anysphere'
end)

run_test("Color retrieval function works", function()
    local colors = theme.get_colors()
    return colors and 
           colors.editor_bg and 
           colors.editor_fg and
           type(colors.editor_bg) == "string"
end)

run_test("Lualine theme generation works", function()
    local lualine_theme = theme.get_lualine_theme()
    return lualine_theme and 
           lualine_theme.normal and
           lualine_theme.insert and
           lualine_theme.visual and
           lualine_theme.normal.a and
           lualine_theme.normal.a.fg
end)

-- Test 5: Transparency Mode Validation
test_section("5. Transparency Mode Validation Tests")

local transparency_modes = {'blended', 'transparent', 'opaque'}

for _, mode in ipairs(transparency_modes) do
    run_test("Transparency mode '" .. mode .. "' processes colors correctly", function()
        local colors = palette.get_colors(mode)
        return colors and 
               colors.editor_bg and 
               colors.comment and
               colors.selection_bg
    end)
end

-- Test 6: New Enhancement Integration
test_section("6. New Enhancement Integration Tests")

run_test("Semantic highlighting tokens are processed", function()
    config.setup({})
    local cfg = config.get()
    local colors = palette.get_colors(cfg.transparency_mode)
    local syntax = require('cursor-dark-anysphere.groups.syntax')
    local groups = syntax.setup(colors, cfg)
    
    -- Test some key semantic tokens
    return groups["@lsp.type.enumMember"] and
           groups["@lsp.type.function.declaration"] and
           groups["@lsp.type.variable.constant"] and
           groups["@lsp.type.method.cpp"]
end)

run_test("Font styling configuration works", function()
    config.setup({
        styles = {
            function_declarations = { bold = true },
            method_declarations = { bold = true },
            cpp_functions = { bold = true }
        }
    })
    local cfg = config.get()
    
    return cfg.styles.function_declarations.bold == true and
           cfg.styles.method_declarations.bold == true and
           cfg.styles.cpp_functions.bold == true
end)

run_test("New plugin configurations are present", function()
    config.setup({})
    local cfg = config.get()
    
    return cfg.plugins.dap == true and
           cfg.plugins.copilot == true and
           cfg.plugins.oil == true and
           cfg.plugins.conform == true and
           cfg.plugins.noice == true
end)

run_test("New UI colors are properly processed", function()
    local colors = palette.get_colors('blended')
    
    return colors.minimap_gutter_added_bg and
           colors.button_secondary_bg and
           colors.input_validation_error_fg and
           colors.extension_button_prominent_bg and
           -- These should be solid colors (no processing needed)
           colors.minimap_gutter_added_bg == palette.vscode_colors.minimap_gutter_added_bg
end)

-- Test 7: Error Handling and Edge Cases
test_section("7. Error Handling and Edge Cases Tests")

run_test("Utils handle invalid hex colors gracefully", function()
    local result1 = utils.process_color("", "#1a1a1a", "blended")
    local result2 = utils.process_color("invalid", "#1a1a1a", "blended")
    local result3 = utils.process_color("NONE", "#1a1a1a", "blended")
    
    return result1 == "" and 
           result2 == "invalid" and 
           result3 == "NONE"
end)

run_test("Color blending works with various alpha values", function()
    local color1 = utils.blend("#FF0000", "#000000", 0.5)
    local color2 = utils.blend("#FF0000", "#000000", 128) -- 255-based alpha
    
    return color1 and color2 and 
           color1:match("^#%x%x%x%x%x%x$") and
           color2:match("^#%x%x%x%x%x%x$")
end)

run_test("Theme handles missing plugin modules gracefully", function()
    -- This should not crash even if a plugin module doesn't exist
    local success = pcall(function()
        theme.setup({
            plugins = {
                nonexistent_plugin = true
            }
        })
    end)
    return success
end)

-- Test 8: Performance and Memory Tests
test_section("8. Performance and Memory Tests")

run_test("Theme setup completes within reasonable time", function()
    local start_time = os.clock()
    theme.setup({})
    local end_time = os.clock()
    
    -- Should complete within 1 second (very generous for Lua operations)
    return (end_time - start_time) < 1.0
end)

run_test("Color processing is efficient for all modes", function()
    local start_time = os.clock()
    
    for i = 1, 100 do
        palette.get_colors('blended')
        palette.get_colors('transparent')
        palette.get_colors('opaque')
    end
    
    local end_time = os.clock()
    
    -- 300 color processing calls should complete quickly
    return (end_time - start_time) < 1.0
end)

-- Test Summary
test_section("Test Summary")

print(string.format("Total Tests: %d", test_results.total))
print(string.format("Passed: %d", test_results.passed))
print(string.format("Failed: %d", test_results.failed))
print(string.format("Success Rate: %.1f%%", (test_results.passed / test_results.total) * 100))

if test_results.failed == 0 then
    print("\n🎉 ALL INTEGRATION TESTS PASSED!")
    print("✓ Theme loading and setup works correctly")
    print("✓ All transparency modes function properly") 
    print("✓ Color processing pipeline is robust")
    print("✓ New enhancements are properly integrated")
    print("✓ Error handling works as expected")
    print("✓ Performance is within acceptable limits")
else
    print(string.format("\n⚠️  %d TESTS FAILED", test_results.failed))
    print("Some components may need attention before deployment")
end

print("\n" .. string.rep("=", 60))
print("Integration test completed.")
print(string.rep("=", 60))
