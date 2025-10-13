return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      {
        mode = { "n", "v" },
        -- { "<leader><tab>", group = "tabs" },
        { "<leader>a", group = "AI", icon = { icon = "", color = "blue" } },
        { "<leader>c", group = "Lsp Extras", icon = { icon = " ", color = "green" } },
        { "<leader>d", group = "Dap", icon = { icon = " ", color = "red" } },
        { "<leader>f", group = "Find", icon = { icon = " ", color = "yellow" } },
        { "<leader>g", group = "Git", icon = { icon = " ", color = "cyan" } },
        { "<leader>l", group = "Lsp Tools", icon = { icon = " ", color = "yellow" } },
        { "<leader>r", group = "Overseer", icon = { icon = " ", color = "cyan" } },
        { "<leader>s", group = "Search", icon = { icon = " ", color = "yellow" } },
        { "<leader>t", group = "NeoTest", icon = { icon = "󰗇 ", color = "red" } },
        { "<leader>T", group = "Terminal", icon = { icon = " ", color = "yellow" } },
        { "<leader>u", group = "Ui", icon = { icon = " ", color = "blue" } },
        { "<leader>q", group = "Trouble", icon = { icon = "󱍼 ", color = "red" } },
        { "<leader>TW", group = "Watcher", icon = { icon = " ", color = "green" } },
        { "<leader>w", group = "Window", icon = { icon = " ", color = "blue" } },
        -- { "<leader>gh", group = "hunks" },
        -- { "<leader>q", group = "quit/session" },
        -- { "<leader>s", group = "search" },
        -- { "<leader>x", group = "Diagnostics", icon = { icon = " ", color = "green" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        -- {
        --   "<leader>b",
        --   group = "buffer",
        --   expand = function()
        --     return require("which-key.extras").expand.buf()
        --   end,
        -- },
        -- {
        --   "<leader>w",
        --   group = "windows",
        --   proxy = "<c-w>",
        --   expand = function()
        --     return require("which-key.extras").expand.win()
        --   end,
        -- },
        -- better descriptions
        -- { "gx", desc = "Open with system app" },
      },
    },
    preset = "helix",
    win = {
      height = { max = 50 },
      padding = { 1, 1 },
      title_pos = "center",
    },
    sort = { "group", "local", "order", "alphanum", "mod" },
  },
}
