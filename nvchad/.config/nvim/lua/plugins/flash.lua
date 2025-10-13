return {
  {
    "folke/flash.nvim",
    -- event = { "BufEnter" },
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "General Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "General Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "General Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "General Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "General Toggle Flash Search" },
    },
  },
}
