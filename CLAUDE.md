# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Neovim colorscheme that ports the Cursor Dark Anysphere VSCode theme. The key technical challenge is handling 85+ colors with alpha transparency values from the VSCode theme, which Neovim doesn't natively support.

## Architecture

### Alpha Transparency Handling

The theme implements three transparency modes to handle RGBA colors:
- **blended** (default): Pre-blends RGBA colors with backgrounds using alpha compositing formula
- **transparent**: Sets backgrounds to `NONE` for terminal transparency  
- **opaque**: Strips alpha channel, uses solid colors only

Alpha blending is handled in `lua/cursor-dark-anysphere/utils.lua` using the formula:
```
result = (foreground × alpha) + (background × (1 - alpha))
```

### Module Structure

1. **Entry Point**: `colors/cursor-dark-anysphere.lua` - Minimal loader for `:colorscheme` command
2. **Main Setup**: `lua/cursor-dark-anysphere/init.lua` - Orchestrates configuration, palette, and highlight groups
3. **Color System**: 
   - `palette.lua`: Contains raw VSCode colors and `get_colors()` which processes alpha based on transparency mode
   - `utils.lua`: Color manipulation functions (hex_to_rgb, blend, lighten, darken)
4. **Highlight Groups** (`groups/` directory):
   - `editor.lua`: UI elements (Normal, StatusLine, FloatBorder, etc.) ~85 groups
   - `syntax.lua`: Base syntax highlighting ~100 groups
   - `treesitter.lua`: Modern syntax with @-prefixed groups ~150 groups
   - `plugins.lua`: Plugin-specific highlights for 15+ plugins

### Key Data Flow

1. User calls `setup(opts)` → config merged with defaults
2. `palette.get_colors(transparency_mode)` → processes all alpha colors based on mode
3. Each group module receives processed colors + config → returns highlight definitions
4. `vim.api.nvim_set_hl()` applies all highlights

## Development Commands

```bash
# Test theme locally
./test_local_install.sh

# Quick test with custom config
nvim -u test_theme.lua

# Test in current Neovim
nvim -c "set rtp+=$(pwd)" -c "colorscheme cursor-dark-anysphere"
```

## Adding New Features

### Adding Plugin Support
1. Add plugin toggle to `config.lua` default_config.plugins
2. Add highlight groups in `groups/plugins.lua` inside conditional block
3. Reference VSCode theme colors from palette

### Modifying Colors
- Raw colors: Edit `palette.lua` vscode_colors table
- Alpha processing: Modify logic in `palette.get_colors()`
- Individual overrides: Use config.colors or config.highlights

### Supporting New Neovim Features
- Add new highlight groups to appropriate file in `groups/`
- Follow naming pattern: builtin highlights → PascalCase, treesitter → @namespace.type

## VSCode Theme Mapping

Key mappings from VSCode to Neovim:
- `editor.background` → `Normal` bg
- `editor.foreground` → `Normal` fg  
- `editorCursor.foreground` → `Cursor`
- `editor.selectionBackground` → `Visual`
- `editorLineNumber.foreground` → `LineNr`
- Terminal colors → `vim.g.terminal_color_0` through `15`

Semantic tokens from VSCode map to treesitter highlights (e.g., `variable.other.property` → `@variable.member`).

## Testing Transparency Modes

The theme must handle colors like `#FFFFFF5C` (white with 36% opacity):
- In blended mode: Pre-blended to `#6B6B6B` (with dark background)
- In transparent mode: Becomes `#FFFFFF` (solid)
- In opaque mode: Becomes `#FFFFFF` (solid)

Use `utils.process_color()` for any new color that might have alpha.