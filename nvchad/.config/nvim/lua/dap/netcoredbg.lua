local M = {}

function M.setup()
  local dap = require "dap"
  if vim.fn.executable "netcoredbg" == 0 then
    vim.notify("Make sure `netcoredbg` is in your path", vim.log.levels.WARN)
    return
  end
  if not dap.adapters["netcoredbg"] then
    require("dap").adapters["netcoredbg"] = {
      type = "executable",
      command = vim.fn.exepath "netcoredbg",
      args = { "--interpreter=vscode" },
      options = {
        detached = false,
      },
    }
  end
  if not dap.configurations["cs"] then
    dap.configurations["cs"] = {
      {
        type = "netcoredbg",
        name = "Launch file",
        request = "launch",
        ---@diagnostic disable-next-line: redundant-parameter
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }
  end
end

return M
