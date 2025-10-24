local prefix = "gs"
local ignore_filetypes = {
	"aerial",
	"alpha",
	"dashboard",
	"help",
	"lazy",
	"mason",
	"neo-tree",
	"NvimTree",
	"neogitstatus",
	"notify",
	"startify",
	"toggleterm",
	"Trouble",
}

local ignore_buftypes = {
	"nofile",
	"prompt",
	"quickfix",
	"terminal",
}

-- 禁用 mini.indentscope 对于某些 filetype
vim.api.nvim_create_autocmd("FileType", {
	desc = "Disable indentscope for certain filetypes",
	callback = function(event)
		if vim.b[event.buf].miniindentscope_disable == nil then
			local filetype = vim.bo[event.buf].filetype
			if vim.tbl_contains(ignore_filetypes, filetype) then
				vim.b[event.buf].miniindentscope_disable = true
			end
		end
	end,
})

-- 禁用 mini.indentscope 对于某些 buftype
vim.api.nvim_create_autocmd("BufWinEnter", {
	desc = "Disable indentscope for certain buftypes",
	callback = function(event)
		if vim.b[event.buf].miniindentscope_disable == nil then
			local buftype = vim.bo[event.buf].buftype
			if vim.tbl_contains(ignore_buftypes, buftype) then
				vim.b[event.buf].miniindentscope_disable = true
			end
		end
	end,
})

-- 禁用 mini.indentscope 对于终端
vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Disable indentscope for terminals",
	callback = function(event)
		if vim.b[event.buf].miniindentscope_disable == nil then
			vim.b[event.buf].miniindentscope_disable = true
		end
	end,
})
local char = "▏"
return {
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPost" },
		opts = function()
			return {
				options = { try_as_border = true },
				symbol = char,
			}
		end,
	},
	{
		"echasnovski/mini.surround",
		event = "BufReadPost",
		keys = {
			{
				prefix,
				mode = { "n" },
				"",
				desc = "General Surround",
			},
		},
		opts = {
			mappings = {
				add = prefix .. "a", -- Add surrounding in Normal and Visual modes
				delete = prefix .. "d", -- Delete surrounding
				find = prefix .. "f", -- Find surrounding (to the right)
				find_left = prefix .. "F", -- Find surrounding (to the left)
				highlight = prefix .. "h", -- Highlight surrounding
				replace = prefix .. "r", -- Replace surrounding
				update_n_lines = prefix .. "n", -- Update `n_lines`
			},
		},
	},
	{
		"sphamba/smear-cursor.nvim",
		enabled = not vim.g.neovide,
		event = "VeryLazy",
		opts = {
			legacy_computing_symbols_support = true,
		},
	},
	-- better text-objects
	{
		"echasnovski/mini.ai",
		event = "BufReadPost",
		keys = {
			{ "a", mode = { "x", "o" } },
			{ "i", mode = { "x", "o" } },
		},
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				event = "BufReadPost",
				init = function()
					-- no need to load the plugin, since we only need its queries
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
				end,
			},
		},
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			local ai = require("mini.ai")
			ai.setup(opts)
		end,
	},
}
