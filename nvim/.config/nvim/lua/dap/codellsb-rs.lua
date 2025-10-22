-- ~/.config/nvim/lua/custom/c_cpp_rust_dap.lua
local M = {}

function M.setup()
	local dap = require("dap")
	local utils = require("dap.utils")
	local is_windows = require("configs.platform").is_windows

	local get_cargo_name = require("dap.utils.cargo")
	local cargo_name = get_cargo_name(require("utils").get_root_dir())

	if vim.fn.executable("codelldb") == 0 then
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

	if not dap.configurations.rust then
		dap.configurations.rust = {}
	end
	-- 配置 C/C++/Rust 的调试配置
	dap.configurations.rust = {
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			-- program = utils.input_exec_path(),
			program = "${workspaceFolder}/target/debug/" .. cargo_name,

			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			terminal = "integrated",
		},
		{
			name = "Debug (with args)",
			type = "codelldb",
			request = "launch",
			program = "${workspaceFolder}/target/debug/" .. cargo_name,
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
end

return M
