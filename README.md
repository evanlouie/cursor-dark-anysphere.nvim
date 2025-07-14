# 🎨 Cursor Dark Anysphere for Neovim

A Neovim port of the Cursor Dark Anysphere VSCode theme with full support for alpha transparency handling, treesitter, and popular plugins.

![Neovim](https://img.shields.io/badge/Neovim-0.8+-green.svg)
![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg)

## ✨ Features

- 🎯 Faithful port of Cursor Dark Anysphere VSCode theme
- 🌈 Smart alpha transparency handling (85+ colors with alpha values)
- 🌳 Full Treesitter support
- 🔌 Integration with 15+ popular plugins
- 🎨 Multiple transparency modes: `blended`, `transparent`, `opaque`
- ⚡ Optimized for LazyVim
- 🖥️ Terminal colors support

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "evanlouie/cursor-dark-anysphere.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- your configuration
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "evanlouie/cursor-dark-anysphere.nvim",
  config = function()
    require("cursor-dark-anysphere").setup({
      -- your configuration
    })
  end,
})
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'evlouie/cursor-dark-anysphere.nvim'
```

## 🚀 Usage

### Basic Setup

```lua
-- Lua
require("cursor-dark-anysphere").setup()
vim.cmd("colorscheme cursor-dark-anysphere")
```

```vim
" Vimscript
colorscheme cursor-dark-anysphere
```

### LazyVim Integration

For LazyVim users, add this to your plugins:

```lua
return {
  -- Theme
  {
    "evanlouie/cursor-dark-anysphere.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- your configuration
    },
  },
  
  -- Configure LazyVim to use this colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cursor-dark-anysphere",
    },
  },
}
```

## ⚙️ Configuration

### Default Configuration

```lua
require("cursor-dark-anysphere").setup({
  style = 'dark',
  transparent = false,
  transparency_mode = 'blended', -- 'blended' | 'transparent' | 'opaque'
  ending_tildes = false,
  cmp_itemkind_reverse = false,
  
  -- Toggle specific transparency elements
  transparencies = {
    floats = true,      -- Use blend for floating windows
    popups = true,      -- Use blend for popups
    sidebar = false,    -- Transparent sidebars
    statusline = false  -- Transparent statusline
  },
  
  -- Style options matching VSCode theme
  styles = {
    comments = { italic = true },
    keywords = { italic = false },
    functions = { bold = true },
    variables = {},
    operators = {},
    booleans = {},
    strings = {},
    types = {},
    numbers = {},
    parameters = { italic = true },
  },
  
  -- Override specific colors
  colors = {},
  
  -- Override specific highlights
  highlights = {},
  
  -- Plugin-specific settings
  plugins = {
    telescope = true,
    nvim_tree = true,
    neo_tree = true,
    nvim_cmp = true,
    lualine = true,
    gitsigns = true,
    treesitter = true,
    indent_blankline = true,
    dashboard = true,
    which_key = true,
    trouble = true,
    todo_comments = true,
    lazy = true,
    mini = true,
  },
})
```

### Transparency Modes

The theme offers three transparency modes to handle the 85+ alpha colors from the VSCode theme:

1. **`blended`** (default): Pre-blends all alpha colors with appropriate backgrounds
2. **`transparent`**: Sets backgrounds to `NONE` for terminal transparency
3. **`opaque`**: Removes all transparency, uses solid colors only

Example:
```lua
-- Full transparency
require("cursor-dark-anysphere").setup({
  transparent = true, -- Sets transparency_mode to 'transparent'
})

-- Selective transparency
require("cursor-dark-anysphere").setup({
  transparency_mode = 'blended',
  transparencies = {
    floats = true,
    sidebar = true,
    statusline = true,
  },
})
```

### Lualine Integration

```lua
require('lualine').setup({
  options = {
    theme = require('cursor-dark-anysphere').get_lualine_theme(),
    -- or simply:
    -- theme = 'cursor-dark-anysphere',
  },
})
```

### Customization Examples

#### Override specific colors:
```lua
require("cursor-dark-anysphere").setup({
  colors = {
    editor_bg = "#000000",
    comment = "#808080",
  },
})
```

#### Override specific highlights:
```lua
require("cursor-dark-anysphere").setup({
  highlights = {
    Normal = { bg = "#000000" },
    ["@function"] = { fg = "#FFD700", bold = true },
  },
})
```

#### Disable specific plugins:
```lua
require("cursor-dark-anysphere").setup({
  plugins = {
    telescope = false,
    trouble = false,
  },
})
```

## 🎨 Color Palette

The theme features a carefully crafted color palette:

- **Background**: `#1a1a1a` (editor), `#141414` (UI)
- **Foreground**: `#D8DEE9`
- **Comments**: `#FFFFFF5C` (white with 36% opacity)
- **Blues**: `#81A1C1`, `#88C0D0`, `#87c3ff`, `#82d2ce`
- **Greens**: `#A3BE8C`, `#a8cc7c`
- **Yellows**: `#EBCB8B`, `#efb080`, `#ebc88d`, `#f8c762`
- **Red**: `#BF616A`
- **Purples**: `#B48EAD`, `#aaa0fa`, `#AA9BF5`, `#af9cff`
- **Pink**: `#e394dc`

## 🔌 Supported Plugins

- **File Explorers**: nvim-tree, neo-tree
- **Fuzzy Finders**: Telescope
- **Completion**: nvim-cmp
- **Git**: gitsigns
- **Status Line**: lualine
- **Syntax**: treesitter
- **UI**: indent-blankline, dashboard, which-key
- **Diagnostics**: trouble
- **Comments**: todo-comments
- **Package Manager**: lazy.nvim
- **Mini Ecosystem**: mini.nvim suite

## 🐛 Known Issues

- Neovim doesn't support true RGBA colors. The theme uses three strategies to handle this:
  - Pre-blending colors with backgrounds
  - Using the `blend` parameter for floating windows
  - Offering full transparency mode
- The `blend` parameter only works for floating windows and popups, not regular editor highlighting

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Original Cursor Dark Anysphere theme by Anysphere
- Inspired by the VSCode theme structure and design

---

<p align="center">Made with ❤️ for the Neovim community</p>