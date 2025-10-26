local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local icons = require "configs.heirline.common"
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local workdir_color = { bg = "#f38ba8" }
return utils.surround({ separators.rounded_left, separators.rounded_right }, workdir_color.bg, {
  init = function(self)
    self.icon = " "

    self.cwd = string.match(require("utils").get_root_dir(), "([^/]+)/?$")
  end,
  hl = { fg = "gray", bg = workdir_color.bg, bold = true },
  on_click = {
    callback = function()
      vim.cmd "Neotree toggle"
    end,
    name = "heirline_workdir",
  },
  {
    provider = function(self)
      -- local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. self.cwd
    end,
  },
})
