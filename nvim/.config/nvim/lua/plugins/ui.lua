-- stylua: ignore
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
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects(require('utils.projects'))", },
            { icon = " ", key = "d", desc = "Dirs", action = ":lua require('utils.dir').open_dir()", },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
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
    enabled = false,
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
  {
    "echasnovski/mini.icons",
    event = "vimEnter",
    config = function()
      require("mini.icons").setup {
        extension = {
          lua = { hl = "MiniIconsBlue" },
          c = { glyph = '' },
          ["c++"] = { glyph = '' },
          cc = { glyph = '' },
          cpp = { glyph = '' },
          cppm = { glyph = "" },
          h = { glyph = "" },
          hpp = { glyph = "" },
          -- cmake = { glyph = "" }

        },
        lsp = {
          array = { glyph = "", hl = "MiniIconsOrange" },
          boolean = { glyph = "", hl = "MiniIconsOrange" },
          class = { glyph = "", hl = "MiniIconsPurple" },
          color = { glyph = "", hl = "MiniIconsRed" },
          constant = { glyph = "", hl = "MiniIconsOrange" },
          constructor = { glyph = "", hl = "MiniIconsAzure" },
          enum = { glyph = "", hl = "MiniIconsPurple" },
          enummember = { glyph = "", hl = "MiniIconsYellow" },
          event = { glyph = "", hl = "MiniIconsRed" },
          field = { glyph = "", hl = "MiniIconsYellow" },
          file = { glyph = "", hl = "MiniIconsBlue" },
          folder = { glyph = "", hl = "MiniIconsBlue" },
          ["function"] = { glyph = "󰊕", hl = "MiniIconsAzure" },
          interface = { glyph = "", hl = "MiniIconsPurple" },
          key = { glyph = "", hl = "MiniIconsYellow" },
          keyword = { glyph = "", hl = "MiniIconsCyan" },
          method = { glyph = "", hl = "MiniIconsAzure" },
          module = { glyph = "", hl = "MiniIconsPurple" },
          namespace = { glyph = "", hl = "MiniIconsRed" },
          null = { glyph = "", hl = "MiniIconsGrey" },
          number = { glyph = "", hl = "MiniIconsOrange" },
          object = { glyph = "", hl = "MiniIconsGrey" },
          operator = { glyph = "", hl = "MiniIconsCyan" },
          package = { glyph = "", hl = "MiniIconsPurple" },
          property = { glyph = "", hl = "MiniIconsYellow" },
          reference = { glyph = "", hl = "MiniIconsCyan" },
          snippet = { glyph = "", hl = "MiniIconsGreen" },
          string = { glyph = "", hl = "MiniIconsGreen" },
          struct = { glyph = "", hl = "MiniIconsPurple" },
          text = { glyph = "󰉿", hl = "MiniIconsGreen" },
          typeparameter = { glyph = "", hl = "MiniIconsCyan" },
          unit = { glyph = "", hl = "MiniIconsCyan" },
          value = { glyph = "", hl = "MiniIconsBlue" },
          variable = { glyph = "󰀫", hl = "MiniIconsCyan" },
        },
      }
      MiniIcons.tweak_lsp_kind "prepend"
    end,
  },
}
