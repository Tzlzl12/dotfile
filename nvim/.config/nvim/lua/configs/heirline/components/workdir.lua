local workdir_color = { bg = "None", fg = "red" }

local M = {}

M.workDir = {
  init = function(self)
    self.icon = " "

    self.cwd = string.match(require("utils").get_root_dir(), "([^/]+)/?$")
  end,
  hl = { fg = workdir_color.fg, bg = workdir_color.bg, bold = true },
  on_click = {
    callback = function()
      vim.cmd "Neotree toggle"
    end,
    name = "heirline_workdir",
  },
  {
    provider = function(self)
      return self.icon .. self.cwd
    end,
  },
}

return M
