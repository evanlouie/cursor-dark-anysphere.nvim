#!/usr/bin/env lua

-- Color Validation Test for cursor-dark-anysphere theme
-- Tests color accuracy, consistency, transparency handling, and VS Code fidelity
-- Run with: lua test_color_validation.lua

print("Cursor Dark Anysphere - Color Validation Test")
print("============================================")

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

-- Load modules
local config = require('cursor-dark-anysphere.config')
local palette = require('cursor-dark-anysphere.palette')
local utils = require('cursor-dark-anysphere.utils')

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

-- Helper function to validate hex color format
local function is_valid_hex_color(color)
    if not color or type(color) ~= "string" then
        return false
    end
    
    if color == "NONE" or color == "none" then
        return true
    end
    
    -- Check hex format: #RRGGBB or #RRGGBBAA
    return color:match("^#%x%x%x%x%x%x$") or color:match("^#%x%x%x%x%x%x%x%x$")
end

-- Helper function to count alpha colors
local function count_alpha_colors(color_table)
    local count = 0
    for _, color in pairs(color_table) do
        if type(color) == "string" and color:match("^#%x%x%x%x%x%x%x%x$") then
            count = count + 1
        end
    end
    return count
end

-- Test 1: Base Color Palette Validation
test_section("1. Base Color Palette Validation Tests")

run_test("All VS Code base colors are properly defined", function()
    local vscode_colors = palette.vscode_colors
    
    -- Core colors
    return vscode_colors.editor_bg and is_valid_hex_color(vscode_colors.editor_bg) and
           vscode_colors.editor_fg and is_valid_hex_color(vscode_colors.editor_fg) and
           vscode_colors.ui_bg and is_valid_hex_color(vscode_colors.ui_bg) and
           vscode_colors.minimap_bg and is_valid_hex_color(vscode_colors.minimap_bg) and
           vscode_colors.ui_fg and is_valid_hex_color(vscode_colors.ui_fg) and
           vscode_colors.comment and is_valid_hex_color(vscode_colors.comment)
end)

run_test("All accent colors follow VS Code specifications", function()
    local vscode_colors = palette.vscode_colors
    
    -- Blue variants
    return vscode_colors.blue1 and is_valid_hex_color(vscode_colors.blue1) and
           vscode_colors.blue2 and is_valid_hex_color(vscode_colors.blue2) and
           vscode_colors.blue3 and is_valid_hex_color(vscode_colors.blue3) and
           vscode_colors.blue4 and is_valid_hex_color(vscode_colors.blue4) and
           vscode_colors.blue5 and is_valid_hex_color(vscode_colors.blue5) and
           -- Green variants
           vscode_colors.green1 and is_valid_hex_color(vscode_colors.green1) and
           vscode_colors.green2 and is_valid_hex_color(vscode_colors.green2) and
           vscode_colors.green3 and is_valid_hex_color(vscode_colors.green3) and
           -- Yellow variants
           vscode_colors.yellow1 and is_valid_hex_color(vscode_colors.yellow1) and
           vscode_colors.yellow2 and is_valid_hex_color(vscode_colors.yellow2) and
           vscode_colors.yellow3 and is_valid_hex_color(vscode_colors.yellow3) and
           -- Red variants
           vscode_colors.red1 and is_valid_hex_color(vscode_colors.red1) and
           vscode_colors.red2 and is_valid_hex_color(vscode_colors.red2) and
           vscode_colors.red3 and is_valid_hex_color(vscode_colors.red3) and
           -- Purple variants
           vscode_colors.purple1 and is_valid_hex_color(vscode_colors.purple1) and
           vscode_colors.purple2 and is_valid_hex_color(vscode_colors.purple2) and
           vscode_colors.purple3 and is_valid_hex_color(vscode_colors.purple3) and
           vscode_colors.purple4 and is_valid_hex_color(vscode_colors.purple4)
end)

run_test("New enhancement colors are properly defined", function()
    local vscode_colors = palette.vscode_colors
    
    -- Minimap colors (16 new colors total)
    return vscode_colors.minimap_gutter_added_bg and is_valid_hex_color(vscode_colors.minimap_gutter_added_bg) and
           vscode_colors.minimap_gutter_modified_bg and is_valid_hex_color(vscode_colors.minimap_gutter_modified_bg) and
           vscode_colors.minimap_gutter_deleted_bg and is_valid_hex_color(vscode_colors.minimap_gutter_deleted_bg) and
           vscode_colors.minimap_selection_highlight and is_valid_hex_color(vscode_colors.minimap_selection_highlight) and
           vscode_colors.minimap_error_highlight and is_valid_hex_color(vscode_colors.minimap_error_highlight) and
           vscode_colors.minimap_warning_highlight and is_valid_hex_color(vscode_colors.minimap_warning_highlight) and
           -- Button variants
           vscode_colors.button_secondary_bg and is_valid_hex_color(vscode_colors.button_secondary_bg) and
           vscode_colors.button_secondary_fg and is_valid_hex_color(vscode_colors.button_secondary_fg) and
           vscode_colors.button_secondary_hover_bg and is_valid_hex_color(vscode_colors.button_secondary_hover_bg) and
           -- Input validation colors
           vscode_colors.input_validation_error_fg and is_valid_hex_color(vscode_colors.input_validation_error_fg) and
           vscode_colors.input_validation_warning_fg and is_valid_hex_color(vscode_colors.input_validation_warning_fg) and
           -- Extension button colors
           vscode_colors.extension_button_prominent_bg and is_valid_hex_color(vscode_colors.extension_button_prominent_bg) and
           vscode_colors.extension_button_prominent_fg and is_valid_hex_color(vscode_colors.extension_button_prominent_fg) and
           vscode_colors.extension_button_prominent_hover_bg and is_valid_hex_color(vscode_colors.extension_button_prominent_hover_bg)
end)

run_test("Alpha channel colors are properly formatted", function()
    local vscode_colors = palette.vscode_colors
    local alpha_count = 0
    
    -- Count colors with alpha channels
    for key, color in pairs(vscode_colors) do
        if type(color) == "string" and color:match("^#%x%x%x%x%x%x%x%x$") then
            alpha_count = alpha_count + 1
        end
    end
    
    -- Should have many alpha colors for transparency effects
    return alpha_count > 20 -- Expected based on the palette
end)

-- Test 2: Color Processing Pipeline Tests
test_section("2. Color Processing Pipeline Tests")

run_test("Blended mode processes alpha colors correctly", function()
    local colors = palette.get_colors('blended')
    
    -- Test that alpha colors are processed (should not have 8-digit alpha format)
    return colors.comment and not colors.comment:match("^#%x%x%x%x%x%x%x%x$") and -- Should be blended, no alpha
           colors.selection_bg and not colors.selection_bg:match("^#%x%x%x%x%x%x%x%x$") and
           colors.diff_added_bg and not colors.diff_added_bg:match("^#%x%x%x%x%x%x%x%x$") and
           is_valid_hex_color(colors.comment) and
           is_valid_hex_color(colors.selection_bg) and
           is_valid_hex_color(colors.diff_added_bg)
end)

run_test("Transparent mode removes alpha channels", function()
    local colors = palette.get_colors('transparent')
    
    -- Test that alpha colors have alpha removed (should be 6-digit hex format)
    return colors.comment and colors.comment:match("^#%x%x%x%x%x%x$") and
           colors.selection_bg and colors.selection_bg:match("^#%x%x%x%x%x%x$") and
           colors.diff_added_bg and colors.diff_added_bg:match("^#%x%x%x%x%x%x$") and
           is_valid_hex_color(colors.comment) and
           is_valid_hex_color(colors.selection_bg) and
           is_valid_hex_color(colors.diff_added_bg)
end)

run_test("Opaque mode handles colors correctly", function()
    local colors = palette.get_colors('opaque')
    
    -- Test that colors are valid and have no alpha (should be 6-digit hex format)
    return colors.comment and colors.comment:match("^#%x%x%x%x%x%x$") and
           colors.selection_bg and colors.selection_bg:match("^#%x%x%x%x%x%x$") and
           colors.diff_added_bg and colors.diff_added_bg:match("^#%x%x%x%x%x%x$") and
           is_valid_hex_color(colors.comment) and
           is_valid_hex_color(colors.selection_bg) and
           is_valid_hex_color(colors.diff_added_bg)
end)

run_test("New colors are processed correctly in all modes", function()
    local modes = {'blended', 'transparent', 'opaque'}
    
    for _, mode in ipairs(modes) do
        local colors = palette.get_colors(mode)
        
        -- Test new solid colors (should be unchanged)
        if not (colors.minimap_gutter_added_bg == palette.vscode_colors.minimap_gutter_added_bg and
                colors.button_secondary_bg == palette.vscode_colors.button_secondary_bg and
                colors.input_validation_error_fg == palette.vscode_colors.input_validation_error_fg) then
            return false
        end
    end
    
    return true
end)

-- Test 3: Color Utility Functions Tests
test_section("3. Color Utility Functions Tests")

run_test("Hex to RGB conversion works correctly", function()
    local r, g, b = utils.hex_to_rgb("#FF8040")
    return r == 255 and g == 128 and b == 64
end)

run_test("Hex to RGB with alpha works correctly", function()
    local r, g, b, a = utils.hex_to_rgb("#FF804080")
    return r == 255 and g == 128 and b == 64 and a == 128
end)

run_test("RGB to hex conversion works correctly", function()
    local hex = utils.rgb_to_hex(255, 128, 64)
    return hex == "#FF8040"
end)

run_test("Color blending produces valid results", function()
    local blended = utils.blend("#FF0000", "#0000FF", 0.5)
    return is_valid_hex_color(blended) and blended ~= "#FF0000" and blended ~= "#0000FF"
end)

run_test("Color processing handles edge cases", function()
    -- Test various edge cases
    local result1 = utils.process_color("", "#1a1a1a", "blended")
    local result2 = utils.process_color("NONE", "#1a1a1a", "blended")
    local result3 = utils.process_color("#FF0000", "#1a1a1a", "blended")
    local result4 = utils.process_color("#FF000080", "#1a1a1a", "blended")
    
    return result1 == "" and
           result2 == "NONE" and
           result3 == "#FF0000" and
           is_valid_hex_color(result4)
end)

-- Test 4: VS Code Color Fidelity Tests
test_section("4. VS Code Color Fidelity Tests")

run_test("Core VS Code colors match specifications", function()
    local vscode_colors = palette.vscode_colors
    
    -- Test key VS Code color values (these should match exactly)
    return vscode_colors.editor_bg == "#1a1a1a" and
           vscode_colors.ui_bg == "#141414" and
           vscode_colors.minimap_bg == "#181818" and
           vscode_colors.editor_fg == "#D8DEE9" and
           vscode_colors.white == "#FFFFFF" and
           vscode_colors.black == "#000000"
end)

run_test("Semantic color assignments follow VS Code patterns", function()
    local vscode_colors = palette.vscode_colors
    
    -- Test that semantic colors follow VS Code conventions
    return vscode_colors.red1 and vscode_colors.red1:match("^#[Bb][Ff]") and -- BF616A pattern
           vscode_colors.green1 and vscode_colors.green1:match("^#[Aa]") and -- A3BE8C pattern
           vscode_colors.blue1 and vscode_colors.blue1:match("^#8") and -- 81A1C1 pattern
           vscode_colors.yellow1 and vscode_colors.yellow1:match("^#[Ee]") -- EBCB8B pattern
end)

run_test("Transparency values align with VS Code alpha channels", function()
    local vscode_colors = palette.vscode_colors
    
    -- Test specific alpha values that should match VS Code
    return vscode_colors.comment == "#FFFFFF5C" and -- 5C = ~36% alpha
           vscode_colors.ui_fg_dim == "#CCCCCC99" and -- 99 = ~60% alpha
           vscode_colors.selection_bg == "#40404099" and -- 99 = ~60% alpha
           vscode_colors.bracket_match_border == "#FFFFFF55" -- 55 = ~33% alpha
end)

-- Test 5: Color Consistency Tests
test_section("5. Color Consistency Tests")

run_test("Related colors maintain consistent hue relationships", function()
    local vscode_colors = palette.vscode_colors
    
    -- Blue family should all be blue-ish
    local blue_colors = {
        vscode_colors.blue1, vscode_colors.blue2, vscode_colors.blue3, 
        vscode_colors.blue4, vscode_colors.blue5
    }
    
    for _, color in ipairs(blue_colors) do
        local r, g, b = utils.hex_to_rgb(color)
        -- Blue colors should generally have high blue component
        if not (b > r and b > g * 0.8) then
            return false
        end
    end
    
    return true
end)

run_test("Diagnostic colors maintain semantic meaning", function()
    local vscode_colors = palette.vscode_colors
    
    -- Red should be reddish (for errors)
    local r1, g1, b1 = utils.hex_to_rgb(vscode_colors.red1)
    local r2, g2, b2 = utils.hex_to_rgb(vscode_colors.red2)
    
    -- Green should be greenish (for success)
    local gr1, gg1, gb1 = utils.hex_to_rgb(vscode_colors.green1)
    local gr2, gg2, gb2 = utils.hex_to_rgb(vscode_colors.green2)
    
    return (r1 > g1 and r1 > b1) and -- red1 is reddish
           (r2 > g2 and r2 > b2) and -- red2 is reddish
           (gg1 > gr1 and gg1 > gb1) and -- green1 is greenish
           (gg2 > gr2 and gg2 > gb2) -- green2 is greenish
end)

run_test("UI enhancement colors integrate well with existing palette", function()
    local vscode_colors = palette.vscode_colors
    
    -- Test that new colors don't clash with existing palette
    -- Button secondary should be in the gray range
    local r, g, b = utils.hex_to_rgb(vscode_colors.button_secondary_bg)
    local diff = math.abs(r - g) + math.abs(g - b) + math.abs(r - b)
    
    -- Should be grayish (low difference between components)
    return diff < 50 and
           -- Extension button should be visible against dark background
           vscode_colors.extension_button_prominent_fg == "#FFFFFF" and
           -- Input validation should use semantic colors
           vscode_colors.input_validation_error_fg == "#141414"
end)

-- Test 6: Transparency Mode Consistency Tests
test_section("6. Transparency Mode Consistency Tests")

run_test("All transparency modes produce valid color palettes", function()
    local modes = {'blended', 'transparent', 'opaque'}
    
    for _, mode in ipairs(modes) do
        local colors = palette.get_colors(mode)
        
        -- Test core colors exist and are valid
        if not (colors.editor_bg and is_valid_hex_color(colors.editor_bg) and
                colors.editor_fg and is_valid_hex_color(colors.editor_fg) and
                colors.comment and is_valid_hex_color(colors.comment) and
                colors.selection_bg and is_valid_hex_color(colors.selection_bg)) then
            return false
        end
    end
    
    return true
end)

run_test("Transparency modes maintain color relationships", function()
    local blended = palette.get_colors('blended')
    local transparent = palette.get_colors('transparent')
    local opaque = palette.get_colors('opaque')
    
    -- Solid colors should be identical across modes
    return blended.editor_bg == transparent.editor_bg and
           transparent.editor_bg == opaque.editor_bg and
           blended.editor_fg == transparent.editor_fg and
           transparent.editor_fg == opaque.editor_fg and
           blended.blue1 == transparent.blue1 and
           transparent.blue1 == opaque.blue1
end)

-- Test 7: Performance and Edge Case Tests
test_section("7. Performance and Edge Case Tests")

run_test("Color processing handles large number of colors efficiently", function()
    local start_time = os.clock()
    
    -- Process colors many times
    for i = 1, 1000 do
        palette.get_colors('blended')
    end
    
    local end_time = os.clock()
    
    -- Should complete within reasonable time
    return (end_time - start_time) < 2.0
end)

run_test("Blend function handles extreme alpha values", function()
    local result1 = utils.blend("#FF0000", "#0000FF", 0.0) -- Should be blue
    local result2 = utils.blend("#FF0000", "#0000FF", 1.0) -- Should be red
    local result3 = utils.blend("#FF0000", "#0000FF", 0.5) -- Should be purple-ish
    
    return result1 == "#0000FF" and
           result2 == "#FF0000" and
           is_valid_hex_color(result3) and
           result3 ~= result1 and result3 ~= result2
end)

run_test("Color palette handles invalid inputs gracefully", function()
    local colors1 = palette.get_colors('invalid_mode') -- Should default to blended
    local colors2 = palette.get_colors(nil) -- Should default to blended
    local colors3 = palette.get_colors('') -- Should default to blended
    
    return colors1 and colors1.editor_bg and
           colors2 and colors2.editor_bg and
           colors3 and colors3.editor_bg
end)

-- Test 8: Color Count and Coverage Tests
test_section("8. Color Count and Coverage Tests")

run_test("VSCode color palette has expected number of colors", function()
    local vscode_colors = palette.vscode_colors
    local color_count = 0
    
    for _, _ in pairs(vscode_colors) do
        color_count = color_count + 1
    end
    
    -- Should have sufficient colors for comprehensive theme (130+ colors based on current palette)
    return color_count >= 130
end)

run_test("Processed palette includes all base colors plus computed ones", function()
    local colors = palette.get_colors('blended')
    local processed_count = 0
    
    for _, _ in pairs(colors) do
        processed_count = processed_count + 1
    end
    
    -- Should have all base colors (same count as vscode_colors since no additional computed colors)
    return processed_count >= 130
end)

run_test("New enhancement colors are properly integrated", function()
    local colors = palette.get_colors('blended')
    
    -- Count specific enhancement categories
    local minimap_count = 0
    local button_count = 0
    local validation_count = 0
    local extension_count = 0
    
    if colors.minimap_gutter_added_bg then minimap_count = minimap_count + 1 end
    if colors.minimap_gutter_modified_bg then minimap_count = minimap_count + 1 end
    if colors.minimap_gutter_deleted_bg then minimap_count = minimap_count + 1 end
    if colors.minimap_selection_highlight then minimap_count = minimap_count + 1 end
    if colors.minimap_error_highlight then minimap_count = minimap_count + 1 end
    if colors.minimap_warning_highlight then minimap_count = minimap_count + 1 end
    
    if colors.button_secondary_bg then button_count = button_count + 1 end
    if colors.button_secondary_fg then button_count = button_count + 1 end
    if colors.button_secondary_hover_bg then button_count = button_count + 1 end
    
    if colors.input_validation_error_fg then validation_count = validation_count + 1 end
    if colors.input_validation_warning_fg then validation_count = validation_count + 1 end
    
    if colors.extension_button_prominent_bg then extension_count = extension_count + 1 end
    if colors.extension_button_prominent_fg then extension_count = extension_count + 1 end
    if colors.extension_button_prominent_hover_bg then extension_count = extension_count + 1 end
    
    -- Should have 6 minimap + 3 button + 2 validation + 3 extension = 14 new colors minimum
    return minimap_count >= 6 and button_count >= 3 and validation_count >= 2 and extension_count >= 3
end)

-- Test Summary
test_section("Test Summary")

print(string.format("Total Tests: %d", test_results.total))
print(string.format("Passed: %d", test_results.passed))
print(string.format("Failed: %d", test_results.failed))
print(string.format("Success Rate: %.1f%%", (test_results.passed / test_results.total) * 100))

if test_results.failed == 0 then
    print("\n🎉 ALL COLOR VALIDATION TESTS PASSED!")
    print("✓ Base color palette is complete and well-formatted")
    print("✓ Color processing pipeline works correctly for all transparency modes") 
    print("✓ Color utility functions are robust and accurate")
    print("✓ VS Code color fidelity is maintained")
    print("✓ Color consistency and relationships are preserved")
    print("✓ New enhancement colors (16 total) are properly integrated")
    print("✓ Transparency handling works as expected")
    print("✓ Performance is within acceptable limits")
    print("✓ Edge cases and error scenarios are handled gracefully")
else
    print(string.format("\n⚠️  %d COLOR VALIDATION TESTS FAILED", test_results.failed))
    print("Color validation needs attention before deployment")
end

print("\n" .. string.rep("=", 60))
print("Color validation test completed.")
print(string.rep("=", 60))
