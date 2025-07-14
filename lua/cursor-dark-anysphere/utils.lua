local M = {}

-- Convert hex color to RGB components
---@param hex string Hex color like "#RRGGBB" or "#RRGGBBAA"
---@return number r Red component (0-255)
---@return number g Green component (0-255)
---@return number b Blue component (0-255)
---@return number? a Alpha component (0-255) if present
function M.hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = nil
    
    if #hex == 8 then
        a = tonumber(hex:sub(7, 8), 16)
    end
    
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

-- Blend two colors using alpha compositing
---@param fg string Foreground color (hex)
---@param bg string Background color (hex)
---@param alpha number Alpha value (0-1) or (0-255)
---@return string hex Blended color
function M.blend(fg, bg, alpha)
    -- Normalize alpha to 0-1 range
    if alpha > 1 then
        alpha = alpha / 255
    end
    
    local fr, fg, fb = M.hex_to_rgb(fg)
    local br, bg, bb = M.hex_to_rgb(bg)
    
    -- Alpha compositing formula: result = fg * alpha + bg * (1 - alpha)
    local r = fr * alpha + br * (1 - alpha)
    local g = fg * alpha + bg * (1 - alpha)
    local b = fb * alpha + bb * (1 - alpha)
    
    return M.rgb_to_hex(r, g, b)
end

-- Process a color that might have alpha
---@param color string Color in hex format
---@param bg string Background color to blend with
---@param mode string 'blended', 'transparent', or 'opaque'
---@return string hex Processed color
function M.process_color(color, bg, mode)
    if not color or color == "" then
        return color
    end
    
    -- Handle special values
    if color == "NONE" or color == "none" then
        return "NONE"
    end
    
    local r, g, b, a = M.hex_to_rgb(color)
    
    -- If no alpha, return as-is
    if not a then
        return color
    end
    
    -- Handle based on mode
    if mode == "transparent" then
        -- For transparent mode, remove alpha and use solid color
        return M.rgb_to_hex(r, g, b)
    elseif mode == "opaque" then
        -- For opaque mode, ignore alpha completely
        return M.rgb_to_hex(r, g, b)
    else -- "blended" mode (default)
        -- Blend with background
        return M.blend(M.rgb_to_hex(r, g, b), bg, a)
    end
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

return M