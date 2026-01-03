-- #ff0000
return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    -- build = nil,
    opts = { -- set to setup table
      user_default_options = {
        mode = "virtualtext",
        virtualtext = "󱓻",
        virtualtext_inline = "before",
      },
    },
  },
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    -- event = "VeryLazy",
    ft = { "markdown", "png", "jpg", "jpeg" },
    opts = {
      processor = "magick_cli",
      backend = "kitty",
    },
  },
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
    --
  },
  {
    "folke/ts-comments.nvim",
    event = "BufReadPost",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    cmd = "LazyDev",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "folke/persistence.nvim",
    event = "VeryLazy", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
  },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   cmd = { "ToggleTerm", "TermExec" },
  --   opts = {
  --     highlights = {
  --       Normal = { link = "Normal" },
  --       NormalNC = { link = "NormalNC" },
  --       NormalFloat = { link = "NormalFloat" },
  --       FloatBorder = { link = "FloatBorder" },
  --       StatusLine = { link = "StatusLine" },
  --       StatusLineNC = { link = "StatusLineNC" },
  --       WinBar = { link = "WinBar" },
  --       WinBarNC = { link = "WinBarNC" },
  --     },
  --     size = 10,
  --     shading_factor = 2,
  --     float_opts = { border = "rounded" },
  --   },
  -- },
}
