return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    -- keys = {
    --   "<leader>ul",
    --   function()
    --     local bufnr = vim.api.nvim_get_current_buf()
    --     require("rainbow-delimiters").toggle(bufnr)
    --     require("noice").notify(
    --       string.format(
    --         "Buffer rainbow delimeters %s",
    --         require("rainbow-delimiters").is_enabled(bufnr) and "on" or "off"
    --       )
    --     )
    --   end,
    --   desc = "Toggle rainbow delimeters (buffer)",
    -- },

    event = "BufReadPost",
    main = "rainbow-delimiters.setup",
    opts = {
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        python = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
      },
    },
  },
}
