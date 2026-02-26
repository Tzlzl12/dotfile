return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        keywords = "italic",
        virtural_text = "italic",
      },
      options = {
        -- cursorline = true, -- Use cursorline highlighting?
        -- transparency = vim.g.transparent_enable, -- Use a transparent background?
        terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
        -- lualine_transparency = true,             -- Center bar transparency?
        highlight_inactive_windows = true, -- When the window is out of focus, change the normal background?
      },
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
      -- transparent_background = vim.g.transparent_enable,
      integrations = {
        flash = true,
        gitsigns = true,
        mini = {
          enabled = true,
        },
        neotree = true,
        neotest = true,
        dap = true,
        dap_ui = true,
        overseer = true,
        render_markdown = true,
        lsp_trouble = true,
        which_key = true,
      },
      default_integrations = false,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      -- transparent_mode = vim.g.transparent_enable,
      italic = {
        strings = true,
        operators = false,
        comments = true,
      },
      contrast = "hard",
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        -- transparent = vim.g.transparent_enable
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      -- transparent = vim.g.transparent_enable,
      style = "moon",
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
      },
    },
  },
  {
    "AstroNvim/astrotheme",
    lazy = true,
    opts = {
      style = {
        -- transparent = vim.g.transparent_enable, -- Bool value, toggles transparency.
      },
      plugins = {
        ["blink.cmp"] = false,
      },
    },
  },
}
