# Changelog

All notable changes to the Cursor Dark Anysphere colorscheme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- SnacksIndent highlight groups for LazyVim compatibility (2025-07-14)

### Fixed
- Invisible indent guides by using solid colors in palette (2025-07-14)

## [0.1.0] - 2025-07-14

### Added
- Initial release of Cursor Dark Anysphere colorscheme for Neovim
- Complete port of VSCode Cursor Dark Anysphere theme
- Support for 85+ colors with alpha transparency handling
- Three transparency modes: blended (default), transparent, and opaque
- Comprehensive highlight groups for:
  - Editor UI elements (~85 groups)
  - Base syntax highlighting (~100 groups)
  - Treesitter syntax highlighting (~150 groups)
  - 15+ popular plugins
- File explorer support for NvimTree, NeoTree, and Oil.nvim
- Snacks.nvim explorer support for LazyVim
- Terminal color support
- LSP and diagnostic highlighting
- Git integration highlighting
- Telescope integration
- Which-key integration
- Trouble.nvim integration
- Indent guide support for indent-blankline.nvim and snacks.nvim
- Alpha transparency blending system with proper color processing
- Configuration system with customizable colors and highlight overrides
- Performance optimizations with color caching
- Comprehensive testing utilities

### Fixed
- Sidebar and file explorer text contrast issues
- Missing NvimTree file highlight groups
- Comprehensive file explorer highlight improvements
- Invisible indent guides through solid color implementation

### Changed
- Cleaned up unnecessary exploratory code
- Enhanced VS Code fidelity with comprehensive theme improvements
- Improved color processing for better alpha transparency handling

---

*This changelog was automatically generated from git history and will be maintained going forward.*