return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		-- keys = {
		--   "<leader>ul",
		--   function()
		--     local bufnr = vim.api.nvim_get_current_buf()
		--     require("rainbow-delimiters").toggle(bufnr)
		--     require("noice").notify(
		--       string.format(
		--         "Buffer rainbow delimeters %s",
		--         require("rainbow-delimiters").is_enabled(bufnr) and "on" or "off"
		--       )
		--     )
		--   end,
		--   desc = "Toggle rainbow delimeters (buffer)",
		-- },

		event = "BufReadPost",
		main = "rainbow-delimiters.setup",
		opts = {
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
				python = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
			},
		},
		config = function()
			-- 在你的 colorscheme 配置文件中，或者 init.lua 中
			vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f7768e" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#e0af68" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#7aa2f7" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff9e64" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#9ece6a" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#bb9af7" })
			vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#7dc4e4" })
		end,
	},
}
