return {
  {
    "AstroNvim/astrotheme",
    lazy = true,
    opts = {
      style = {
        transparent = true,
        inactive = false,
      },
      plugins = {
        ["dashboard-nvim"] = true,
        ["flash"] = true,
        ["fzf"] = true,
        ["gitsigns"] = true,
        ["rainbow-delimiters"] = true,
        ["nvim-web-devicons"] = true,
        ["nvim-cmp"] = true,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      on_highlights = function(hl, _)
        -- hl.Pmenu = { bg = "NONE", fg = "NONE"}
        -- hl.PmenuTumb = { bg = "NONE", fg = "NONE" }
        -- hl.PmenuSbar = { bg = "NONE", fg = "NONE" }
        -- hl.CursorLine = { bg = "NONE", fg = "NONE" }
        hl.WinBar = { bg = "NONE", fg = "NONE" }
        hl.WinBarNC = { bg = "NONE", fg = "NONE" }
        -- hl.PmenuTumb = { bg = "NONE", fg = "NONE" }
      end,
    },
  },
}
