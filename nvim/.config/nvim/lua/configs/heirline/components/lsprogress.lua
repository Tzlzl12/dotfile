local conditions = require "heirline.conditions"
local icons = require("configs.icons").icons

local M = {}
M.LspIcon = {
  condition = function()
    return conditions.lsp_attached()
  end,
  update = { "LspAttach", "LspDetach", "WinEnter" },
  provider = function(self)
    local names = {}
    return icons.ActiveLSP
  end,
  hl = { fg = "green", bold = true },
  on_click = {
    name = "heirline_LSP",
    callback = function()
      vim.schedule(function()
        vim.cmd "LspInfo"
      end)
    end,
  },
}
M.LspInfo = {
  condition = function()
    return conditions.lsp_attached()
  end,
  update = { "LspAttach", "LspDetach", "WinEnter" },
  -- provider = icons.ActiveLSP .. "LSP",
  provider = function(self)
    local names = {}
    return vim.lsp.get_clients()[1].config.name
  end,
  hl = { fg = "green", bold = true },
}
return M
