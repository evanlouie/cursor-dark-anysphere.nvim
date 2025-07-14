#!/bin/bash

# Test script for local theme installation
# Usage: ./test_local_install.sh

echo "🎨 Testing cursor-dark-anysphere local installation..."
echo

# Create a minimal test config
TEMP_CONFIG=$(mktemp -d)
echo "📁 Creating temporary config at: $TEMP_CONFIG"

# Create minimal init.lua
cat > "$TEMP_CONFIG/init.lua" << 'EOF'
-- Add current theme directory to runtimepath
vim.opt.runtimepath:prepend(vim.fn.getcwd())

-- Basic settings
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Load the theme
require('cursor-dark-anysphere').setup({
  transparency_mode = 'blended',
})

vim.cmd('colorscheme cursor-dark-anysphere')

-- Create test buffer
vim.cmd([[
  enew
  setlocal buftype=nofile
  call setline(1, [
    \ '-- Cursor Dark Anysphere Theme Test',
    \ '',
    \ '-- Comments should be dim',
    \ 'local function hello(name)',
    \ '  local message = "Hello, " .. name',
    \ '  print(message)',
    \ '  return true',
    \ 'end',
    \ '',
    \ 'hello("World")'
  \ ])
  setlocal filetype=lua
]])

print("✅ Theme loaded successfully!")
print("Press :q to exit")
EOF

# Run Neovim with the test config
echo "🚀 Launching Neovim with test config..."
echo
nvim -u "$TEMP_CONFIG/init.lua"

# Cleanup
rm -rf "$TEMP_CONFIG"
echo "🧹 Cleaned up temporary files"