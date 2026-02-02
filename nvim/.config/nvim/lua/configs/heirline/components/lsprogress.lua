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
  provider = function()
    local clients = vim.lsp.get_clients() -- 当前 buffer 的所有 clients

    if #clients == 0 then
      return "" -- 或 "No LSP"，看你喜好
    end

    for _, client in ipairs(clients) do
      if client.config.name ~= "copilot" then
        return client.config.name
      end
    end

    return clients[1].config.name -- 安全取第一个
  end,
  hl = { fg = "green", bold = true },
}
return M
