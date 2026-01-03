return {
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    opts = {
      plugins = { -- Override which plugin highlight groups are loaded
        blink_cmp = true,
        codecompanion = true,
        flash_nvim = true,
        gitsigns = true,
        lsp_semantic_tokens = true,
        mini_diff = true,
        mini_indentscope = true,
        neotest = true,
        neo_tree = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_lsp = true,
        persisted = true,
        rainbow_delimiters = true,
        render_markdown = true,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        which_key = true,
      },
      options = {
        cursorline = true, -- Use cursorline highlighting?
        transparency = true, -- Use a transparent background?
        terminal_colors = true, -- Use the theme's colors for Neovim's :terminal?
        lualine_transparency = true, -- Center bar transparency?
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
      transparent_background = true,
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
      transparent_mode = true,
      italic = {
        strings = true,
        operators = false,
        comments = true,
      },
      contrast = "hard",
    },
  },
  { "EdenEast/nightfox.nvim", lazy = true, opts = {
    optioms = { transparent = true },
  } },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
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
        transparent = true, -- Bool value, toggles transparency.
      },
    },
  },
}
