return {
  {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    config = function()
      require "configs.heirline"
    end,
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {

          header = [[

	           ▄▄         ▄ ▄▄▄▄▄▄▄   
	         ▄▀███▄     ▄██ █████▀    
	         ██▄▀███▄   ███           
	         ███  ▀███▄ ███           
	         ███    ▀██ ███           
	         ███      ▀ ███           
	         ▀██ █████▄▀█▀▄██████▄    
	           ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   

	            Powered By eovim     
	                   ]],
	         -- stylua: ignore
	         ---@type snacks.dashboard.Item[]
	         keys = {
	           -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
	           -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
	           -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
	           -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
	           { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects(require('utils.projects'))",},
	           { icon = " ", key = "d", desc = "Dirs", action = ":lua require('utils.dir').open_dir()",},
	           { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"},
	           { icon = " ", key = "s", desc = "Session", action = ":lua require('persistence').load({ last = true })" },
	           { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
	           { icon = " ", key = "q", desc = "Quit", action = ":qa" },
	         },
        },
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = function()
      return {
        override = {
          default_icon = { icon = "󰈚", name = "Default" },
          js = { icon = "󰌞", name = "js" },
          ts = { icon = "󰛦", name = "ts" },
          lock = { icon = "󰌾", name = "lock" },
          ["robots.txt"] = { icon = "󰚩", name = "robots" },
        },
      }
    end,
  },
}
