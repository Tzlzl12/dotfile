local Align = { provider = "%=" }
local Space = { provider = " " }
local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local components = require "configs.heirline.components"
local icons = require "configs.heirline.common"
local separators = require("configs.heirline.common").separators
local CloseButton = {
  condition = function(self)
    return not vim.bo.modified
  end,
  update = { "WinNew", "WinClosed", "BufEnter" },
  { provider = " " },
  {
    provider = icons.close,
    hl = { fg = "gray" },
    on_click = {
      callback = function(_, minwid)
        vim.api.nvim_win_close(minwid, true)
      end,
      minwid = function()
        return vim.api.nvim_get_current_win()
      end,
      name = "heirline_winbar_close_button",
    },
  },
}

local WinBar = {
  Align,
  -- require "configs.heirline.components.winbar_dap",
  require "configs.heirline.components.winbar_buildsystem",
}

return WinBar
