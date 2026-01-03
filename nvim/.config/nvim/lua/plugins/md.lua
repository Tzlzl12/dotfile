return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "quatro", "codecompanion" },
    opts = {
      file_types = { "markdown", "quatro", "codecompanion" },
      anti_conceal = { enabled = true },
      render_modes = { "n", "v", "c" },
      latex = {
        -- Turn on / off latex rendering.
        enabled = true,
        -- Executable used to convert latex formula to rendered unicode.
        converter = "latex2text",
        -- Determines where latex formula is rendered relative to block.
        -- | above | above latex block |
        -- | below | below latex block |
        position = "below",
      },
    },
    completions = {
      -- Settings for blink.cmp completions source
      blink = { enabled = true },

      -- Settings for in-process language server completions
      lsp = { enabled = false },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
