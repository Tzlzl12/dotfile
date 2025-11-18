local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local icons = require("configs.icons").icons
local separators = require("configs.heirline.common").separators

local git_color = "green"
return {
  condition = function()
    return conditions.is_git_repo()
  end,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  on_click = {
    callback = function(self, minwid, nclicks, button)
      vim.defer_fn(function()
        local git = ""
        local terminal = require("toggleterm.terminal").Terminal
        if vim.fn.executable "gitui" == 1 then
          git = "gitui"
        elseif vim.fn.executable "lazygit" == 1 then
          git = "lazygit"
        else
          print "not found any git tui, such as `lazygit` or `gitui`"
          return
        end
        local node_term = terminal:new {
          cmd = git,
          dir = "git_dir",
          direction = "float",
          hidden = true,
          close_on_exit = true,
          float_opts = {
            border = "double",
          },
        }
        node_term:toggle()
      end, 100)
    end,
    name = "heirline_git",
    update = false,
  },
  {
    provider = function(self)
      return icons.GitBranch .. " " .. self.status_dict.head
    end,
    hl = { bold = true, fg = "yellow" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "(",
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and icons.GitAdd
    end,
    hl = { fg = "green" },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and "×" .. count
    end,
  },
  {
    condition = function(self)
      local count = self.status_dict.added or 0
      return count > 0
    end,
    provider = " ",
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and icons.GitDelete
    end,
    hl = { fg = "red" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and "×" .. count
    end,
  },
  {
    condition = function(self)
      local count = self.status_dict.removed or 0
      return count > 0
    end,
    provider = " ",
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and icons.GitChange
    end,
    hl = { fg = "orange" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and "×" .. count
    end,
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}
