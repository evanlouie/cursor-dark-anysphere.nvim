-- Basic test file to verify the theme loads correctly
-- Run with: nvim -u test_theme.lua

-- Set up minimal init
vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set packpath=/tmp/nvim/site]]

-- Add current directory to runtimepath
local current_dir = vim.fn.getcwd()
vim.opt.runtimepath:prepend(current_dir)

-- Basic settings
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Load and setup the theme
local ok, theme = pcall(require, 'cursor-dark-anysphere')
if not ok then
  print("Error loading theme:", theme)
  return
end

-- Test different configurations
print("Testing cursor-dark-anysphere theme...")

-- Test 1: Default configuration
print("\n1. Testing default configuration")
theme.setup()
vim.cmd("colorscheme cursor-dark-anysphere")
print("   ✓ Default configuration loaded")

-- Test 2: Transparent mode
print("\n2. Testing transparent mode")
theme.setup({
  transparent = true,
})
print("   ✓ Transparent mode loaded")

-- Test 3: Blended mode with custom transparencies
print("\n3. Testing blended mode with custom transparencies")
theme.setup({
  transparency_mode = 'blended',
  transparencies = {
    floats = true,
    sidebar = true,
    statusline = true,
  },
})
print("   ✓ Blended mode with custom transparencies loaded")

-- Test 4: Opaque mode
print("\n4. Testing opaque mode")
theme.setup({
  transparency_mode = 'opaque',
})
print("   ✓ Opaque mode loaded")

-- Test 5: Custom styles
print("\n5. Testing custom styles")
theme.setup({
  styles = {
    comments = { italic = true, bold = true },
    functions = { underline = true },
  },
})
print("   ✓ Custom styles loaded")

-- Test 6: Get colors
print("\n6. Testing color retrieval")
local colors = theme.get_colors()
print("   Editor background:", colors.editor_bg)
print("   Editor foreground:", colors.editor_fg)
print("   Comment color:", colors.comment)
print("   ✓ Colors retrieved successfully")

-- Test 7: Lualine theme
print("\n7. Testing lualine theme generation")
local lualine_theme = theme.get_lualine_theme()
if lualine_theme and lualine_theme.normal then
  print("   ✓ Lualine theme generated successfully")
else
  print("   ✗ Failed to generate lualine theme")
end

-- Create some test content
vim.cmd [[
  syntax on
  split
  enew
  setlocal buftype=nofile
  call setline(1, [
    \ '# Cursor Dark Anysphere Theme Test',
    \ '',
    \ '-- This is a comment with italic style',
    \ 'local function testFunction(param1, param2)',
    \ '  local myVariable = "This is a string"',
    \ '  local myNumber = 42',
    \ '  local myBoolean = true',
    \ '  ',
    \ '  if myBoolean then',
    \ '    print("Hello, World!")',
    \ '  end',
    \ '  ',
    \ '  return {',
    \ '    variable = myVariable,',
    \ '    number = myNumber,',
    \ '    boolean = myBoolean,',
    \ '  }',
    \ 'end',
    \ '',
    \ '-- TODO: This is a todo comment',
    \ '-- FIXME: This needs fixing',
    \ '-- NOTE: Important note here',
    \ ''
  \ ])
  setlocal filetype=lua
]]

print("\n✅ All tests completed!")
print("\nTheme loaded successfully. You should see:")
print("- Syntax highlighted Lua code")
print("- Comments in italic (if supported by your terminal)")
print("- Different colors for strings, numbers, booleans, functions, etc.")
print("\nPress any key to exit...")