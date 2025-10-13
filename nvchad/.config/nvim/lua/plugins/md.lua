vim.b.use_render_md = true

return {
  {
    "OXY2DEV/markview.nvim",
    enabled = not vim.b.use_render_md,
    lazy = false,
    opts = {
      preview = {
        icon_provider = "devicons",
        filetypes = { "markdown", "codecompanion" },
        modes = { "n", "no", "c" },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = vim.b.use_render_md,
    -- event = { "FileType markdown" },
    -- cmd = { "RenderMarkdown" },
    ft = { "markdown", "quatro", "codecompanion" },
    opts = {
      file_types = { "markdown", "quatro", "codecompanion" },
      anti_conceal = { enabled = true },
      render_modes = { "n", "v", "i", "c" },
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
    -- ft = { "markdown", "quarto" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
}
