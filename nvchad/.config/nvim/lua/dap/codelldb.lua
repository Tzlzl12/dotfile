-- ~/.config/nvim/lua/custom/c_cpp_rust_dap.lua
local M = {}

function M.setup()
  local dap = require "dap"
  local utils = require "dap.utils"
  local is_windows = require("configs.platform").is_windows

  local file = vim.fn.expand "%:p"
  local current_dir = vim.fn.expand "%:p:h"
  local file_without_ext = vim.fn.fnamemodify(file, ":t:r")
  local program = current_dir .. "/bin/" .. file_without_ext

  local get_cmake_name = require "dap.utils.cmake"
  local cmake_name = get_cmake_name(vim.fn.getcwd())
  if vim.fn.executable "codelldb" == 0 then
    vim.notify("Make sure `codelldb` is in your path", vim.log.levels.WARN)
    return
  end
  -- 配置 codelldb 适配器
  dap.adapters.codelldb = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = {
        "--port",
        "${port}",
      },
    },
  }

  if not dap.configurations.c then
    dap.configurations.c = {}
  end

  -- 配置 C/C++/Rust 的调试配置
  dap.configurations.c = {
    {
      name = "Debug",
      type = "codelldb",
      request = "launch",
      -- program = utils.input_exec_path(),
      program = program,

      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      terminal = "integrated",
    },

    {
      name = "Debug (with args)",
      type = "codelldb",
      request = "launch",
      program = program,
      args = utils.input_args(),
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      terminal = "integrated",
    },
    {
      name = "Attach to a running process",
      type = "codelldb",
      request = "attach",
      pid = utils.pick_process,
      cwd = "${workspaceFolder}",
      program = utils.input_exec_path(),
      stopOnEntry = false,
      waitFor = true,
    },
  }

  local cwd = vim.fn.getcwd()
  if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
    local cmake = {
      name = "Debug With CMake",
      type = "codelldb",
      request = "launch",
      program = "${workspaceFolder}/build/" .. cmake_name,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      terminal = "integrated",
    }
    table.insert(dap.configurations.c, cmake)
  end
  -- 复用 C 的配置给 C++ 和 Rust
  dap.configurations.cpp = dap.configurations.c
  -- dap.configurations.rust = dap.configurations.c
end

return M
