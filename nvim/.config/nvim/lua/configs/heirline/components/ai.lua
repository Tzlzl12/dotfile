local M = {}
M.Ai = {
  init = function(self)
    self.copilot = " "
    self.codeium = "󰘦 "
  end,
  provider = function(self)
    if vim.g.use_copilot then
      return self.copilot
    else
      return self.codeium
    end
  end,
  hl = function(self)
    return { fg = "#3DD598" }
  end,
}

return M
