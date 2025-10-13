local M = {}

function M.setup()
  local dap = require "dap"
  local get_cargo_name = require "dap.utils.cargo"
  local cargo_name = get_cargo_name(require("utils").get_root_dir())
  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "OpenDebugAD7",
    options = {
      detached = false,
    },
  }

  local configs = {
    {
      name = "Debug STM32 (OpenOCD + GDB)",
      type = "cppdbg",
      request = "launch",
      program = "${workspaceFolder}/target/thumbv7m-none-eabi/debug/" .. cargo_name,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      setupCommands = {
        {
          text = "set architecture arm",
          description = "Set architecture to ARM",
          ignoreFailures = false,
        },
        {
          text = "set gnutarget elf32-littlearm",
          description = "Set target to ARM ELF",
          ignoreFailures = false,
        },
        {
          text = "file ${workspaceFolder}/target/thumbv7m-none-eabi/debug/your-project",
          description = "Load symbol file",
          ignoreFailures = false,
        },
        {
          text = "target extended-remote localhost:3333",
          description = "Connect to OpenOCD",
          ignoreFailures = false,
        },
        {
          text = "monitor reset halt",
          description = "Reset and halt target",
          ignoreFailures = false,
        },
        {
          text = "load",
          description = "Load program to target",
          ignoreFailures = false,
        },
        {
          text = "monitor reset halt",
          description = "Reset and halt after load",
          ignoreFailures = false,
        },
      },
      customLaunchSetupCommands = {
        {
          text = "target extended-remote localhost:3333",
          description = "Connect to OpenOCD",
        },
      },
      launchCompleteCommand = "exec-continue",
      linux = {
        MIMode = "gdb",
        miDebuggerPath = "gdb-multiarch", -- 或者 arm-none-eabi-gdb
      },
      osx = {
        MIMode = "gdb",
        miDebuggerPath = "gdb-multiarch",
      },
      windows = {
        MIMode = "gdb",
        miDebuggerPath = "gdb-multiarch.exe",
      },
    },
    {
      name = "Attach to STM32 (OpenOCD)",
      type = "cppdbg",
      request = "attach",
      program = "${workspaceFolder}/target/thumbv7m-none-eabi/debug/" .. cargo_name,
      cwd = "${workspaceFolder}",
      setupCommands = {
        {
          text = "set architecture arm",
          description = "Set architecture to ARM",
          ignoreFailures = false,
        },
        {
          text = "target extended-remote localhost:3333",
          description = "Connect to OpenOCD",
          ignoreFailures = false,
        },
      },
      linux = {
        MIMode = "gdb",
        miDebuggerPath = "gdb-multiarch",
      },
    },
  }
  if vim.fn.filereadable(vim.uv.cwd() .. "/memory.x") then
    dap.configurations.rust = configs
  end
end
return M
