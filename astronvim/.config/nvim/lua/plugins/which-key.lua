return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    win = {
      height = { max = 50 },
      padding = { 1, 1 },
      title_pos = "center",
    },
    sort = { "group", "local", "order", "alphanum", "mod" },
  },
}
