-- vim.cmd [[
-- highlight RainbowRed guifg=#FF6F61
-- highlight RainbowYellow guifg=#FFB74D
-- highlight RainbowBlue guifg=#64B5F6
-- highlight RainbowOrange guifg=#FF8A65
-- highlight RainbowGreen guifg=#A5D6A7
-- highlight RainbowViolet guifg=#BA68C8
-- highlight RainbowCyan guifg=#80DEEA
-- ]]

return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>u("] = {
                function()
                  local bufnr = vim.api.nvim_get_current_buf()
                  require("rainbow-delimiters").toggle(bufnr)
                  require("astrocore").notify(
                    string.format(
                      "Buffer rainbow delimeters %s",
                      require("rainbow-delimiters").is_enabled(bufnr) and "on" or "off"
                    )
                  )
                end,
                desc = "Toggle rainbow delimeters (buffer)",
              },
            },
          },
        },
      },
    },

    event = "User AstroFile",
    main = "rainbow-delimiters.setup",
    opts = {
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
        lua = 210,
      },
    },
  },
}
