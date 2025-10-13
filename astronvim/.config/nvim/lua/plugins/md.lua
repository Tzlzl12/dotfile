return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    -- "echasnovski/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  -- cmd = { "RenderMarkown" },
  opts = {
    file_types = { "markdown", "quatro" },
    anti_conceal = { enabled = true },
    render_modes = { "n", "v", "i", "c" },
  },
  -- ft = { "markdown", "quarto" },
  config = function(_, opts) require("render-markdown").setup(opts) end,
}
