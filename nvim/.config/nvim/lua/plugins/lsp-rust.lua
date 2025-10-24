-- if not vim.g.nvchad_lsp.rust then
-- 	return {}
-- end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "rust", "toml" } },
	},
	{
		"mrcjkb/rustaceanvim",
		version = vim.fn.has("nvim-0.10.0") == 0 and "^5" or false,
		ft = { "rust" },
		enabled = vim.g.nvchad_lsp_rust,
		opts = {
			server = {
				on_attach = function(client, bufnr)
					require("keymaps.lsp")
					require("keymaps.goto")
					-- require("lsp.default_config").on_attach(client, bufnr)
					vim.keymap.set("n", "gh", function()
						vim.lsp.buf.hover({
							border = "rounded",
						})
					end, { desc = "Lsp Hover", buffer = bufnr })
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code action" })
					vim.keymap.set("n", "<leader>ce", function()
						vim.cmd.RustLsp("expandMacro")
					end, { desc = "Lsp Diagnose", buffer = bufnr })
					vim.keymap.set("n", "<leader>cf", function()
						vim.cmd.RustLsp("joinLines")
					end, { desc = "Lsp JoinLines", buffer = bufnr })
					vim.keymap.set("n", "<leader>cl", function()
						vim.cmd.RustLsp("code len")
					end, { desc = "Lsp CodeLens", buffer = bufnr })
					vim.keymap.set("n", "<leader>cr", function()
						vim.cmd.RustLsp("debuggables")
					end, { desc = "Lsp Rust Debuggables", buffer = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						check = {
							allTargets = false,
							targets = "x86_64-unknown-linux-gnu",
						},
						-- Add clippy lints for Rust.
						checkOnSave = true,
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			if vim.fn.filereadable(vim.uv.cwd() .. "/memory.x") == 1 then
				opts.server.default_settings["rust-analyzer"].check.allTargets = false
				opts.server.default_settings["rust-analyzer"].check.targets = "thumbv7em-none-eabihf"
			end
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
			if vim.fn.executable("rust-analyzer") == 0 then
				vim.notify(
					"**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
					1
				)
			end
		end,
	},
	{
		"nvim-neotest/neotest",
		opts = function(_, opts)
			if not opts.adapters then
				opts.adapters = {}
			end
			local rustaceanvim_avail, rustaceanvim = pcall(require, "rustaceanvim.neotest")
			if rustaceanvim_avail then
				table.insert(opts.adapters, rustaceanvim)
			end
		end,
	},
	{
		"Saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				rust_analyzer = { enabled = false },
			},
		},
	},
}
