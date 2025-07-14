local M = {}

-- Performance and memory optimization caches
local color_cache = {}
local processed_color_cache = {}
local blend_cache = {}
local rgba_cache = {}

-- Cache statistics for monitoring
local cache_stats = {
    color_hits = 0,
    color_misses = 0,
    processed_hits = 0,
    processed_misses = 0,
    blend_hits = 0,
    blend_misses = 0,
    memory_cleared = 0
}

-- Memory cleanup threshold (number of cache entries)
local CACHE_THRESHOLD = 1000

-- Generate cache key for color processing
---@param color string Color value
---@param bg string Background color
---@param mode string Processing mode
---@return string key Cache key
local function get_cache_key(color, bg, mode)
    return (color or "nil") .. "|" .. (bg or "nil") .. "|" .. (mode or "blended")
end

-- Clear cache when it gets too large to prevent memory leaks
local function cleanup_caches()
    local total_entries = 0
    for _ in pairs(color_cache) do total_entries = total_entries + 1 end
    for _ in pairs(processed_color_cache) do total_entries = total_entries + 1 end
    for _ in pairs(blend_cache) do total_entries = total_entries + 1 end
    for _ in pairs(rgba_cache) do total_entries = total_entries + 1 end
    
    if total_entries > CACHE_THRESHOLD then
        color_cache = {}
        processed_color_cache = {}
        blend_cache = {}
        rgba_cache = {}
        cache_stats.memory_cleared = cache_stats.memory_cleared + 1
    end
end

-- Get cache statistics for performance monitoring
---@return table stats Cache performance statistics
function M.get_cache_stats()
    return {
        color_hit_rate = cache_stats.color_hits > 0 and (cache_stats.color_hits / (cache_stats.color_hits + cache_stats.color_misses)) or 0,
        processed_hit_rate = cache_stats.processed_hits > 0 and (cache_stats.processed_hits / (cache_stats.processed_hits + cache_stats.processed_misses)) or 0,
        blend_hit_rate = cache_stats.blend_hits > 0 and (cache_stats.blend_hits / (cache_stats.blend_hits + cache_stats.blend_misses)) or 0,
        total_entries = (function()
            local count = 0
            for _ in pairs(color_cache) do count = count + 1 end
            for _ in pairs(processed_color_cache) do count = count + 1 end
            for _ in pairs(blend_cache) do count = count + 1 end
            for _ in pairs(rgba_cache) do count = count + 1 end
            return count
        end)(),
        memory_clears = cache_stats.memory_cleared,
        stats = cache_stats
    }
end

-- Clear all caches manually
function M.clear_caches()
    color_cache = {}
    processed_color_cache = {}
    blend_cache = {}
    rgba_cache = {}
    cache_stats.memory_cleared = cache_stats.memory_cleared + 1
end

-- Clamp alpha value to valid range (0-1)
---@param alpha number Alpha value to clamp
---@return number clamped Alpha value clamped to 0-1 range
local function clamp_alpha(alpha)
    if not alpha or type(alpha) ~= "number" then
        return 1.0 -- Default to fully opaque
    end
    
    -- Handle extreme values
    if alpha < 0 then
        return 0.0 -- Fully transparent
    elseif alpha > 1 then
        return 1.0 -- Fully opaque
    end
    
    return alpha
end

-- Normalize alpha value from 0-255 range to 0-1 range
---@param alpha number Alpha value (0-255)
---@return number normalized Alpha value (0-1)
local function normalize_alpha(alpha)
    if not alpha or type(alpha) ~= "number" then
        return 1.0
    end
    
    -- Handle negative values
    if alpha < 0.0 then
        return 0.0
    end
    
    -- If already in 0-1 range, clamp and return
    if alpha <= 1.0 then
        return clamp_alpha(alpha)
    end
    
    -- Handle values > 1.0 but <= 255 as 0-255 range
    if alpha <= 255.0 then
        return clamp_alpha(alpha / 255.0)
    end
    
    -- For values > 255, clamp to 1.0
    return 1.0
end

-- Validate color format
---@param color string Color to validate
---@return boolean valid True if color format is valid
---@return string? error Error message if invalid
local function validate_color_format(color)
    if not color or type(color) ~= "string" then
        return false, "Color must be a string"
    end
    
    -- Handle special values
    if color == "NONE" or color == "none" or color == "" then
        return true
    end
    
    -- Remove # prefix if present
    local hex = color:gsub("^#", "")
    
    -- Check for valid hex lengths (3, 6, or 8 digits)
    if #hex ~= 3 and #hex ~= 6 and #hex ~= 8 then
        return false, "Color must be 3, 6, or 8 hex digits (with optional # prefix)"
    end
    
    -- Validate hex characters
    if not hex:match("^%x*$") then
        return false, "Color must contain only valid hex digits (0-9, A-F)"
    end
    
    return true
end

-- Convert hex color to RGB components with enhanced validation and caching
---@param hex string Hex color like "#RRGGBB", "#RRGGBBAA", "#RGB", or "#RGBA"
---@return number? r Red component (0-255)
---@return number? g Green component (0-255)
---@return number? b Blue component (0-255)
---@return number? a Alpha component (0-255) if present
function M.hex_to_rgb(hex)
    -- Check cache first
    if rgba_cache[hex] then
        cache_stats.color_hits = cache_stats.color_hits + 1
        local cached = rgba_cache[hex]
        return cached.r, cached.g, cached.b, cached.a
    end
    
    cache_stats.color_misses = cache_stats.color_misses + 1
    
    local valid, error_msg = validate_color_format(hex)
    if not valid then
        rgba_cache[hex] = {r = nil, g = nil, b = nil, a = nil}
        return nil, nil, nil, nil
    end
    
    -- Handle special values
    if hex == "NONE" or hex == "none" or hex == "" then
        rgba_cache[hex] = {r = nil, g = nil, b = nil, a = nil}
        return nil, nil, nil, nil
    end
    
    -- Normalize hex string
    hex = hex:gsub("^#", ""):upper()
    
    local r, g, b, a
    
    if #hex == 3 then
        -- Convert 3-digit hex to 6-digit (e.g., "F0A" -> "FF00AA")
        r = tonumber(hex:sub(1, 1):rep(2), 16)
        g = tonumber(hex:sub(2, 2):rep(2), 16)
        b = tonumber(hex:sub(3, 3):rep(2), 16)
    elseif #hex == 4 then
        -- Convert 4-digit hex to 8-digit (e.g., "F0A8" -> "FF00AA88")
        r = tonumber(hex:sub(1, 1):rep(2), 16)
        g = tonumber(hex:sub(2, 2):rep(2), 16)
        b = tonumber(hex:sub(3, 3):rep(2), 16)
        a = tonumber(hex:sub(4, 4):rep(2), 16)
    elseif #hex == 6 then
        -- Standard 6-digit hex
        r = tonumber(hex:sub(1, 2), 16)
        g = tonumber(hex:sub(3, 4), 16)
        b = tonumber(hex:sub(5, 6), 16)
    elseif #hex == 8 then
        -- 8-digit hex with alpha
        r = tonumber(hex:sub(1, 2), 16)
        g = tonumber(hex:sub(3, 4), 16)
        b = tonumber(hex:sub(5, 6), 16)
        a = tonumber(hex:sub(7, 8), 16)
    else
        rgba_cache[hex] = {r = nil, g = nil, b = nil, a = nil}
        return nil, nil, nil, nil
    end
    
    -- Validate parsed values
    if not r or not g or not b then
        rgba_cache[hex] = {r = nil, g = nil, b = nil, a = nil}
        return nil, nil, nil, nil
    end
    
    -- Clamp RGB values to valid range
    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))
    
    if a then
        -- Clamp alpha value to valid range
        a = math.max(0, math.min(255, a))
    end
    
    -- Cache the result
    rgba_cache[hex] = {r = r, g = g, b = b, a = a}
    cleanup_caches()
    
    return r, g, b, a
end

-- Convert RGB components to hex color
---@param r number Red component (0-255)
---@param g number Green component (0-255)
---@param b number Blue component (0-255)
---@return string hex Hex color like "#RRGGBB"
function M.rgb_to_hex(r, g, b)
    return string.format("#%02X%02X%02X", 
        math.floor(r + 0.5),
        math.floor(g + 0.5),
        math.floor(b + 0.5)
    )
end

-- Safe color blending with comprehensive validation and caching
---@param fg string Foreground color (hex)
---@param bg string Background color (hex)
---@param alpha number Alpha value (0-1) or (0-255)
---@return string hex Blended color
function M.blend(fg, bg, alpha)
    -- Generate cache key
    local cache_key = (fg or "nil") .. "|" .. (bg or "nil") .. "|" .. tostring(alpha or 0)
    
    -- Check cache first
    if blend_cache[cache_key] then
        cache_stats.blend_hits = cache_stats.blend_hits + 1
        return blend_cache[cache_key]
    end
    
    cache_stats.blend_misses = cache_stats.blend_misses + 1
    
    -- Validate color inputs
    if not fg or type(fg) ~= "string" then
        local result = bg or "#000000"
        blend_cache[cache_key] = result
        return result
    end
    
    if not bg or type(bg) ~= "string" then
        local result = fg or "#000000"
        blend_cache[cache_key] = result
        return result
    end
    
    -- Handle special color values
    if fg == "NONE" or fg == "none" then
        blend_cache[cache_key] = bg
        return bg
    end
    
    if bg == "NONE" or bg == "none" then
        blend_cache[cache_key] = fg
        return fg
    end
    
    -- Validate and normalize alpha
    alpha = normalize_alpha(alpha)
    
    -- Handle extreme alpha values
    if alpha <= 0.0 then
        blend_cache[cache_key] = bg
        return bg -- Fully transparent foreground, show background
    elseif alpha >= 1.0 then
        blend_cache[cache_key] = fg
        return fg -- Fully opaque foreground, show foreground
    end
    
    -- Parse colors with validation
    local fr, fg_g, fb = M.hex_to_rgb(fg)
    local br, bg_g, bb = M.hex_to_rgb(bg)
    
    -- Fallback handling for parsing failures
    if not fr or not fg_g or not fb then
        blend_cache[cache_key] = bg
        return bg -- Return background if foreground parsing failed
    end
    
    if not br or not bg_g or not bb then
        blend_cache[cache_key] = fg
        return fg -- Return foreground if background parsing failed
    end
    
    -- Alpha compositing formula: result = fg * alpha + bg * (1 - alpha)
    local r = fr * alpha + br * (1 - alpha)
    local g = fg_g * alpha + bg_g * (1 - alpha)
    local b = fb * alpha + bb * (1 - alpha)
    
    -- Ensure values are within valid range and convert to hex
    local result = M.rgb_to_hex(
        math.max(0, math.min(255, r)),
        math.max(0, math.min(255, g)),
        math.max(0, math.min(255, b))
    )
    
    -- Cache the result
    blend_cache[cache_key] = result
    cleanup_caches()
    
    return result
end

-- Validate transparency mode
---@param mode any Value to validate as transparency mode
---@return boolean valid True if mode is valid
---@return string? error Error message if invalid
function M.validate_transparency_mode(mode)
    if type(mode) ~= "string" then
        return false, "transparency_mode must be a string"
    end
    
    local valid_modes = { "blended", "transparent", "opaque" }
    for _, valid_mode in ipairs(valid_modes) do
        if mode == valid_mode then
            return true
        end
    end
    
    return false, "transparency_mode must be one of: " .. table.concat(valid_modes, ", ")
end

-- Validate transparency value (for individual transparency options)
---@param value any Value to validate
---@param name string Name of the option for error messages
---@return boolean valid True if value is valid
---@return string? error Error message if invalid
function M.validate_transparency_value(value, name)
    if value == nil then
        return true -- nil is acceptable, will use default
    end
    
    if type(value) == "boolean" then
        return true
    end
    
    if type(value) == "number" then
        if value >= 0.0 and value <= 1.0 then
            return true
        else
            return false, (name or "transparency value") .. " must be between 0.0 and 1.0"
        end
    end
    
    return false, (name or "transparency value") .. " must be a boolean or number between 0.0 and 1.0"
end

-- Process a color with enhanced alpha channel handling and caching
---@param color string Color in hex format
---@param bg string Background color to blend with
---@param mode string 'blended', 'transparent', or 'opaque'
---@return string hex Processed color
function M.process_color(color, bg, mode)
    -- Generate cache key for processed colors
    local cache_key = get_cache_key(color, bg, mode)
    
    -- Check cache first
    if processed_color_cache[cache_key] then
        cache_stats.processed_hits = cache_stats.processed_hits + 1
        return processed_color_cache[cache_key]
    end
    
    cache_stats.processed_misses = cache_stats.processed_misses + 1
    
    -- Handle nil or empty color
    if not color or color == "" then
        local result = color or ""
        processed_color_cache[cache_key] = result
        return result
    end
    
    -- Handle special values
    if color == "NONE" or color == "none" then
        processed_color_cache[cache_key] = "NONE"
        return "NONE"
    end
    
    -- Validate color format
    local valid, error_msg = validate_color_format(color)
    if not valid then
        -- Return original color if format is invalid, but log warning if vim is available
        if vim and vim.notify then
            vim.notify("Invalid color format: " .. tostring(color) .. " - " .. (error_msg or "Unknown error"), vim.log.levels.WARN)
        end
        processed_color_cache[cache_key] = color
        return color
    end
    
    -- Validate and normalize transparency mode
    local mode_valid, mode_err = M.validate_transparency_mode(mode)
    if not mode_valid then
        -- Fallback to blended mode for invalid modes
        mode = "blended"
    end
    
    -- Parse color components with enhanced validation
    local r, g, b, a = M.hex_to_rgb(color)
    
    -- Handle parsing failures gracefully
    if not r or not g or not b then
        processed_color_cache[cache_key] = color
        return color -- Return original if parsing failed
    end
    
    -- If no alpha channel, return as-is (no processing needed)
    if not a then
        processed_color_cache[cache_key] = color
        return color
    end
    
    local result
    -- Process based on transparency mode
    if mode == "transparent" or mode == "opaque" then
        -- For transparent and opaque modes, remove alpha and use solid color
        result = M.rgb_to_hex(r, g, b)
    else -- "blended" mode (default)
        -- Validate background color before blending
        if not bg or bg == "" or bg == "NONE" or bg == "none" then
            -- If no valid background, just return solid color
            result = M.rgb_to_hex(r, g, b)
        else
            -- Validate background color format
            local bg_valid, bg_error = validate_color_format(bg)
            if not bg_valid then
                -- If background is invalid, return solid foreground color
                result = M.rgb_to_hex(r, g, b)
            else
                -- Perform safe blending with normalized alpha
                result = M.blend(M.rgb_to_hex(r, g, b), bg, normalize_alpha(a))
            end
        end
    end
    
    -- Cache the result
    processed_color_cache[cache_key] = result
    cleanup_caches()
    
    return result
end

-- Extract alpha value from hex color
---@param color string Hex color like "#RRGGBBAA"
---@return number? alpha Alpha value (0-100) for Neovim blend parameter
function M.extract_blend(color)
    if not color or color == "" then
        return nil
    end
    
    local _, _, _, a = M.hex_to_rgb(color)
    if a then
        -- Convert alpha to Neovim blend (0-100, where 100 is transparent)
        return math.floor((1 - a / 255) * 100 + 0.5)
    end
    
    return nil
end

-- Lighten a color by a percentage
---@param color string Hex color
---@param percent number Percentage to lighten (0-100)
---@return string hex Lightened color
function M.lighten(color, percent)
    local r, g, b = M.hex_to_rgb(color)
    local factor = percent / 100
    
    r = r + (255 - r) * factor
    g = g + (255 - g) * factor
    b = b + (255 - b) * factor
    
    return M.rgb_to_hex(r, g, b)
end

-- Darken a color by a percentage
---@param color string Hex color
---@param percent number Percentage to darken (0-100)
---@return string hex Darkened color
function M.darken(color, percent)
    local r, g, b = M.hex_to_rgb(color)
    local factor = 1 - (percent / 100)
    
    r = r * factor
    g = g * factor
    b = b * factor
    
    return M.rgb_to_hex(r, g, b)
end

-- Safe table operations with fallback mechanisms
-- These provide robust alternatives to vim.tbl_extend and vim.deepcopy

-- Safe deep copy implementation with fallback
---@param t any Value to deep copy
---@return any copy Deep copy of the input
function M.safe_deepcopy(t)
    -- Use vim.deepcopy if available
    if vim and vim.deepcopy then
        return vim.deepcopy(t)
    end
    
    -- Fallback implementation
    if type(t) ~= "table" then
        return t
    end
    
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = M.safe_deepcopy(v)
    end
    
    return copy
end

-- Safe table extend implementation with fallback
---@param mode string Extend mode ("force", "keep", etc.)
---@param base table Base table to extend
---@param ... table Tables to merge into base
---@return table extended Extended table
function M.safe_tbl_extend(mode, base, ...)
    -- Use vim.tbl_extend if available (non-deep version)
    if vim and vim.tbl_extend then
        return vim.tbl_extend(mode, base, ...)
    end
    
    -- Fallback implementation for shallow extend
    local result = M.safe_deepcopy(base)
    
    for _, overlay in ipairs({...}) do
        if type(overlay) == "table" then
            for k, v in pairs(overlay) do
                if mode == "force" or result[k] == nil then
                    result[k] = v
                end
            end
        end
    end
    
    return result
end

-- Safe deep table extend implementation with fallback
---@param mode string Extend mode ("force", "keep", etc.)
---@param base table Base table to extend
---@param ... table Tables to merge into base
---@return table extended Extended table with deep merging
function M.safe_tbl_deep_extend(mode, base, ...)
    -- Use vim.tbl_deep_extend if available
    if vim and vim.tbl_deep_extend then
        return vim.tbl_deep_extend(mode, base, ...)
    end
    
    -- Fallback implementation for deep extend
    local result = M.safe_deepcopy(base)
    
    for _, overlay in ipairs({...}) do
        if type(overlay) == "table" then
            for k, v in pairs(overlay) do
                if type(v) == "table" and type(result[k]) == "table" then
                    -- Recursively merge tables
                    result[k] = M.safe_tbl_deep_extend(mode, result[k], v)
                elseif mode == "force" or result[k] == nil then
                    result[k] = M.safe_deepcopy(v)
                end
            end
        end
    end
    
    return result
end

-- Validate that table operations work correctly
---@return boolean success True if table operations are working
function M.validate_table_operations()
    local test_table = { a = 1, b = { c = 2 } }
    local test_overlay = { b = { d = 3 }, e = 4 }
    
    -- Test deep copy
    local copied = M.safe_deepcopy(test_table)
    if not copied or copied.a ~= 1 or not copied.b or copied.b.c ~= 2 then
        return false
    end
    
    -- Test shallow extend
    local extended = M.safe_tbl_extend("force", test_table, test_overlay)
    if not extended or extended.e ~= 4 then
        return false
    end
    
    -- Test deep extend
    local deep_extended = M.safe_tbl_deep_extend("force", test_table, test_overlay)
    if not deep_extended or not deep_extended.b or deep_extended.b.c ~= 2 or deep_extended.b.d ~= 3 then
        return false
    end
    
    return true
end

-- Expose utility functions for alpha processing
M.clamp_alpha = clamp_alpha
M.normalize_alpha = normalize_alpha
M.validate_color_format = validate_color_format

-- Additional utility functions for extreme alpha value handling

-- Safe color conversion with extreme alpha handling
---@param color string Color to convert
---@return string? hex Converted color or nil if invalid
function M.safe_color_convert(color)
    local valid, error_msg = validate_color_format(color)
    if not valid then
        return nil
    end
    
    local r, g, b, a = M.hex_to_rgb(color)
    if not r or not g or not b then
        return nil
    end
    
    if a then
        -- Return with normalized alpha
        return string.format("#%02X%02X%02X%02X", r, g, b, math.max(0, math.min(255, a)))
    else
        return M.rgb_to_hex(r, g, b)
    end
end

-- Test alpha processing with extreme values
---@return boolean success True if alpha processing works correctly
function M.test_alpha_processing()
    -- Test extreme alpha values
    local test_cases = {
        {color = "#FF0000FF", expected_alpha = 255}, -- Fully opaque
        {color = "#FF000000", expected_alpha = 0},   -- Fully transparent
        {color = "#FF000080", expected_alpha = 128}, -- 50% alpha
        {color = "#FF0000", expected_alpha = nil},   -- No alpha
    }
    
    for _, test in ipairs(test_cases) do
        local r, g, b, a = M.hex_to_rgb(test.color)
        if not r or r ~= 255 or g ~= 0 or b ~= 0 then
            return false
        end
        
        if test.expected_alpha and (not a or a ~= test.expected_alpha) then
            return false
        end
        
        if not test.expected_alpha and a then
            return false
        end
    end
    
    -- Test alpha normalization
    local normalized = normalize_alpha(128) -- Should be ~0.5
    if math.abs(normalized - 0.5019607843137255) > 0.001 then
        return false
    end
    
    -- Test extreme alpha clamping
    local clamped_high = clamp_alpha(2.0) -- Should be 1.0
    local clamped_low = clamp_alpha(-1.0) -- Should be 0.0
    if clamped_high ~= 1.0 or clamped_low ~= 0.0 then
        return false
    end
    
    return true
end

-- Plugin transparency utility functions

-- Apply transparency to plugin highlight background
---@param highlight table Highlight group definition
---@param transparency_settings table Transparency configuration
---@param fallback_bg string? Fallback background color
---@return table highlight Modified highlight group
function M.apply_transparency_to_plugin(highlight, transparency_settings, fallback_bg)
    if not highlight or type(highlight) ~= "table" then
        return highlight or {}
    end
    
    if not transparency_settings or type(transparency_settings) ~= "table" then
        return highlight
    end
    
    -- Create a copy to avoid modifying the original
    local result = M.safe_deepcopy(highlight)
    
    -- Apply transparency based on settings
    if transparency_settings.floats and result.bg then
        -- For floating windows, use transparency-aware background
        if result.bg == fallback_bg or not fallback_bg then
            result.bg = "NONE"
        end
    end
    
    if transparency_settings.popups and result.bg then
        -- For popup menus, use transparency-aware background
        if result.bg == fallback_bg or not fallback_bg then
            result.bg = "NONE"
        end
    end
    
    if transparency_settings.sidebar and result.bg then
        -- For sidebars, use transparency-aware background
        if result.bg == fallback_bg or not fallback_bg then
            result.bg = "NONE"
        end
    end
    
    return result
end

-- Validate plugin transparency configuration
---@param plugin_highlights table Plugin highlight groups
---@param transparency_settings table Transparency configuration
---@return boolean valid True if transparency integration is valid
---@return table? issues List of validation issues
function M.validate_plugin_transparency(plugin_highlights, transparency_settings)
    local issues = {}
    
    if not plugin_highlights or type(plugin_highlights) ~= "table" then
        table.insert(issues, "Plugin highlights must be a table")
        return false, issues
    end
    
    if not transparency_settings or type(transparency_settings) ~= "table" then
        table.insert(issues, "Transparency settings must be a table")
        return false, issues
    end
    
    -- Check for floating window highlights
    local float_highlights = {
        "Normal", "Border", "Title", "FloatBorder", "Float", "Popup", "PopupBorder"
    }
    
    for group_name, highlight in pairs(plugin_highlights) do
        if type(highlight) == "table" then
            -- Check if this is a floating window highlight
            local is_float = false
            for _, pattern in ipairs(float_highlights) do
                if group_name:match(pattern) then
                    is_float = true
                    break
                end
            end
            
            -- Validate transparency integration for floating windows
            if is_float and transparency_settings.floats then
                if highlight.bg and highlight.bg ~= "NONE" then
                    -- Check if background respects transparency
                    local valid_bg = highlight.bg == "NONE" or
                                   (type(highlight.bg) == "string" and highlight.bg:match("^#%x+$"))
                    if not valid_bg then
                        table.insert(issues, "Invalid transparent background for " .. group_name .. ": " .. tostring(highlight.bg))
                    end
                end
            end
        end
    end
    
    return #issues == 0, #issues > 0 and issues or nil
end

-- Ensure floating window transparency for plugin highlight groups
---@param highlight table Highlight group definition
---@param is_float boolean Whether this is a floating window highlight
---@param transparency_mode string Transparency mode ("blended", "transparent", "opaque")
---@return table highlight Modified highlight group
function M.ensure_plugin_float_transparency(highlight, is_float, transparency_mode)
    if not highlight or type(highlight) ~= "table" then
        return highlight or {}
    end
    
    -- Validate transparency mode
    local mode_valid, _ = M.validate_transparency_mode(transparency_mode)
    if not mode_valid then
        transparency_mode = "blended" -- fallback
    end
    
    local result = M.safe_deepcopy(highlight)
    
    if is_float then
        if transparency_mode == "transparent" then
            -- Full transparency
            result.bg = "NONE"
        elseif transparency_mode == "blended" then
            -- Keep existing background but ensure it's processable
            if result.bg and result.bg ~= "NONE" then
                -- Validate the background color format
                local valid, _ = validate_color_format(result.bg)
                if not valid then
                    result.bg = "NONE" -- fallback for invalid colors
                end
            end
        end
        -- For "opaque" mode, keep original background
    end
    
    return result
end

-- Process plugin highlight groups with transparency integration
---@param plugin_groups table Plugin highlight groups
---@param colors table Color palette
---@param config table Configuration settings
---@return table processed_groups Processed highlight groups with transparency
function M.process_plugin_transparency(plugin_groups, colors, config)
    if not plugin_groups or type(plugin_groups) ~= "table" then
        return {}
    end
    
    if not colors or type(colors) ~= "table" then
        return plugin_groups -- return unmodified if no colors
    end
    
    if not config or type(config) ~= "table" then
        return plugin_groups -- return unmodified if no config
    end
    
    local result = {}
    local transparency_settings = config.transparencies or {}
    local transparency_mode = config.transparency_mode or "blended"
    
    -- Floating window patterns for detection
    local float_patterns = {
        "Float", "Popup", "Border", "Title", "Normal", "Menu", "Preview", "Confirm"
    }
    
    for group_name, highlight in pairs(plugin_groups) do
        if type(highlight) == "table" then
            -- Detect if this is a floating window highlight
            local is_float = false
            for _, pattern in ipairs(float_patterns) do
                if group_name:match(pattern) then
                    is_float = true
                    break
                end
            end
            
            -- Apply transparency processing
            local processed = M.ensure_plugin_float_transparency(highlight, is_float, transparency_mode)
            
            -- Apply additional transparency settings
            if transparency_settings.floats or transparency_settings.popups then
                processed = M.apply_transparency_to_plugin(processed, transparency_settings, colors.ui_bg)
            end
            
            result[group_name] = processed
        else
            result[group_name] = highlight -- copy non-table values as-is
        end
    end
    
    return result
end

-- Bulk color processing for performance optimization
---@param colors table Table of colors to process
---@param bg string Background color to blend with
---@param mode string Processing mode
---@return table processed_colors Processed colors table
function M.process_colors_bulk(colors, bg, mode)
    if not colors or type(colors) ~= "table" then
        return {}
    end
    
    local result = {}
    local start_time = vim and vim.loop and vim.loop.hrtime() or 0
    
    -- Process all colors in batch
    for key, color in pairs(colors) do
        result[key] = M.process_color(color, bg, mode)
    end
    
    -- Log performance if vim is available
    if vim and vim.loop and vim.notify then
        local end_time = vim.loop.hrtime()
        local duration_ms = (end_time - start_time) / 1000000
        if duration_ms > 10 then -- Only log if processing takes > 10ms
            vim.notify(string.format("Bulk color processing: %d colors in %.2fms",
                      (function() local count = 0; for _ in pairs(colors) do count = count + 1 end; return count end)(),
                      duration_ms), vim.log.levels.DEBUG)
        end
    end
    
    return result
end

-- Pre-compute and cache commonly used colors for better performance
---@param color_palette table Base color palette
---@param transparency_mode string Transparency processing mode
---@return table optimized_palette Optimized palette with pre-computed colors
function M.optimize_color_palette(color_palette, transparency_mode)
    if not color_palette or type(color_palette) ~= "table" then
        return {}
    end
    
    -- Create optimized copy
    local optimized = {}
    
    -- Identify commonly used colors that benefit from pre-computation
    local common_colors = {
        "editor_bg", "ui_bg", "editor_fg", "ui_fg",
        "gray1", "gray2", "gray3", "blue1", "blue2",
        "green1", "red1", "yellow1", "purple1"
    }
    
    -- Pre-process common colors
    for _, color_key in ipairs(common_colors) do
        if color_palette[color_key] then
            optimized[color_key] = color_palette[color_key]
            -- Pre-warm cache with common processing combinations
            M.process_color(color_palette[color_key], color_palette.editor_bg or "#1a1a1a", transparency_mode)
            M.process_color(color_palette[color_key], color_palette.ui_bg or "#141414", transparency_mode)
        end
    end
    
    -- Copy remaining colors
    for key, value in pairs(color_palette) do
        if not optimized[key] then
            optimized[key] = value
        end
    end
    
    return optimized
end

-- Memory-efficient highlight group processing
---@param groups table Highlight groups to process
---@param max_batch_size number? Maximum batch size (default: 50)
---@return table processed_groups Processed highlight groups
function M.process_highlight_groups_batched(groups, max_batch_size)
    max_batch_size = max_batch_size or 50
    
    if not groups or type(groups) ~= "table" then
        return {}
    end
    
    local result = {}
    local batch = {}
    local batch_count = 0
    
    -- Process in batches to manage memory usage
    for group_name, highlight in pairs(groups) do
        batch[group_name] = highlight
        batch_count = batch_count + 1
        
        if batch_count >= max_batch_size then
            -- Process current batch
            for name, hl in pairs(batch) do
                result[name] = hl
            end
            
            -- Clear batch for memory efficiency
            batch = {}
            batch_count = 0
            
            -- Force garbage collection if available
            if collectgarbage then
                collectgarbage("step")
            end
        end
    end
    
    -- Process remaining items
    for name, hl in pairs(batch) do
        result[name] = hl
    end
    
    return result
end

-- Performance monitoring utility
---@param operation_name string Name of the operation being monitored
---@param func function Function to execute and monitor
---@param ... any Arguments to pass to the function
---@return any result Function result
function M.monitor_performance(operation_name, func, ...)
    local start_time = vim and vim.loop and vim.loop.hrtime() or 0
    local start_memory = collectgarbage and collectgarbage("count") or 0
    
    local result = func(...)
    
    local end_time = vim and vim.loop and vim.loop.hrtime() or 0
    local end_memory = collectgarbage and collectgarbage("count") or 0
    
    local duration_ms = (end_time - start_time) / 1000000
    local memory_delta = end_memory - start_memory
    
    -- Log performance metrics if significant
    if vim and vim.notify and (duration_ms > 5 or math.abs(memory_delta) > 100) then
        vim.notify(string.format("Performance: %s took %.2fms, memory: %+.1fKB",
                   operation_name, duration_ms, memory_delta), vim.log.levels.DEBUG)
    end
    
    return result
end

-- Test plugin transparency integration
---@return boolean success True if plugin transparency works correctly
function M.test_plugin_transparency()
    -- Test data
    local test_highlights = {
        TestFloat = { fg = "#ffffff", bg = "#000000" },
        TestPopup = { fg = "#ffffff", bg = "#111111" },
        TestNormal = { fg = "#ffffff" },
        TestBorder = { fg = "#888888", bg = "#222222" }
    }
    
    local test_colors = {
        ui_bg = "#1e1e1e"
    }
    
    local test_config = {
        transparency_mode = "transparent",
        transparencies = {
            floats = true,
            popups = true,
            sidebar = false
        }
    }
    
    -- Process with transparency
    local processed = M.process_plugin_transparency(test_highlights, test_colors, test_config)
    
    -- Validate results
    if not processed.TestFloat or processed.TestFloat.bg ~= "NONE" then
        return false
    end
    
    if not processed.TestPopup or processed.TestPopup.bg ~= "NONE" then
        return false
    end
    
    if not processed.TestBorder or processed.TestBorder.bg ~= "NONE" then
        return false
    end
    
    -- Test validation function
    local valid, issues = M.validate_plugin_transparency(processed, test_config.transparencies)
    if not valid then
        return false
    end
    
    return true
end

return M
