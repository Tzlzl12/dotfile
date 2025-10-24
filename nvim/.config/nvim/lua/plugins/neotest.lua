local is_available = require("utils").is_available

return {
	"nvim-neotest/neotest",
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
	},
	keys = function()
		local get_file_path = function()
			return vim.fn.expand("%")
		end
		local get_project_path = function()
			return vim.fn.getcwd()
		end

		local prefix = "<Leader>t"
		local watch_prefix = prefix .. "W"

		return {
			{
				prefix .. "t",
				function()
					require("neotest").run.run()
				end,
				desc = "NeoTest Run test",
			},
			{
				prefix .. "d",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "NeoTest Debug test",
			},
			{
				prefix .. "f",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "NeoTest Run Tests ",
			},
			-- maps.n[prefix .. "p"] = {
			--   function() require("neotest").run.run(get_project_path()) end,
			--   desc = "Run all tests in project",
			-- }
			{
				prefix .. "<CR>",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "NeoTest Test Summary",
			},
			{
				prefix .. "o",
				function()
					require("neotest").output.open()
				end,
				desc = "NeoTest Output hover",
			},
			{
				prefix .. "O",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "NeoTest Output window",
			},
			{
				"]t",
				function()
					require("neotest").jump.next()
				end,
				desc = "NeoTest Next test",
			},
			{
				"[t",
				function()
					require("neotest").jump.prev()
				end,
				desc = "NeoTest Previous test",
			},

			{
				prefix .. "w",
				function()
					require("neotest").watch.toggle()
				end,
				desc = "NeoTest Toggle watch test",
			},
			{
				watch_prefix .. "f",
				function()
					require("neotest").watch.toggle(get_file_path())
				end,
				desc = "NeoTest Toggle watch all test in file",
			},
			{
				watch_prefix .. "p",
				function()
					require("neotest").watch.toggle(get_project_path())
				end,
				desc = "NeoTest Toggle watch all tests in project",
			},
			{
				watch_prefix .. "s",
				function()
					--- NOTE: The proper type of the argument is missing in the documentation
					---@see https://github.com/nvim-neotest/neotest/blob/master/doc/neotest.txt#L626-L632
					---@diagnostic disable-next-line: missing-parameter
					require("neotest").watch.stop()
				end,
				desc = "NeoTest Stop all watches",
			},
		}
	end,
	config = function(_, opts)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					-- Replace newline and tab characters with space for more compact diagnostics
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		require("neotest").setup(opts)
	end,
	opts = {
		status = { virtual_text = true },
		output = { open_on_run = true },
		quickfix = {
			open = function()
				if is_available("trouble.nvim") then
					require("trouble").open({ mode = "quickfix", focus = false })
				else
					vim.cmd("copen")
				end
			end,
		},
	},
}
