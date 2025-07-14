-- Example LazyVim configuration for cursor-dark-anysphere theme
-- Place this in your ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  -- Install the theme
  {
    "evanlouie/cursor-dark-anysphere.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Choose your transparency mode:
      -- 'blended' - Pre-blends alpha colors (default, recommended)
      -- 'transparent' - Full transparency
      -- 'opaque' - No transparency
      transparency_mode = 'blended',
      
      -- Or simply enable full transparency
      -- transparent = true,
      
      -- Fine-tune transparency for specific elements
      transparencies = {
        floats = true,      -- Floating windows use blend
        popups = true,      -- Popup menus use blend
        sidebar = false,    -- File explorer transparency
        statusline = false, -- Status line transparency
      },
      
      -- Customize syntax highlighting styles
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
        parameters = { italic = true },
      },
      
      -- Disable specific plugin integrations if needed
      -- plugins = {
      --   telescope = false,
      --   trouble = false,
      -- },
    },
  },
  
  -- Configure LazyVim to use this colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cursor-dark-anysphere",
    },
  },
  
  -- Optional: Configure lualine to use the theme
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = require('cursor-dark-anysphere').get_lualine_theme()
      return opts
    end,
  },
}