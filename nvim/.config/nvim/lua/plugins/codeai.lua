local prefix = "<leader>a"
local highlight = {
	MiniDiffSignAdd = { link = "GitSignsAdd" },
	MiniDiffSignChange = { link = "GitSignsChange" },
	MiniDiffSignDelete = { link = "GitSignsDelete" },
	MiniDiffOverAdd = { bg = "#40a02b", fg = "#282828" },
	MiniDiffOverChange = { bg = "#df8e1d", fg = "#282828" },
	MiniDiffOverChangeBuf = { bg = "#df8e1d", fg = "#282828" },
	MiniDiffOverContext = { bg = "#df8e1d", fg = "#282828" },
	MiniDiffOverContextBuf = { bg = "#df8e1d", fg = "#282828" },
	MiniDiffOverDelete = { bg = "#d20f39", fg = "#282828" },
}
return {
	{
		"olimorris/codecompanion.nvim",
		keys = {
			{
				prefix .. "a",
				mode = { "n", "x" },
				":CodeCompanion<cr>",
				desc = "AI Command Inline",
			},
			{
				prefix .. "c",
				mode = { "n" },
				":CodeCompanionChat<cr>",
				desc = "AI Chat",
			},
			{
				prefix .. "m",
				mode = { "n" },
				":CodeCompanionActions<cr>",
				desc = "AI Menu",
			},
		},
		opts = {
			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					-- provider = "telescope", -- default|telescope|mini_pick
				},
				chat = {
					window = {
						width = 0.35,
					},
				},
				diff = {
					enabled = true,
					close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
					layout = "buffer", -- vertical|horizontal split for default provider
					opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
					provider = "mini_diff", -- default|mini_diff
				},
				inline = {
					layout = "buffer",
				},
			},
			strategies = {
				chat = {
					adapter = "gemini",
					keymaps = {
						send = {
							modes = { n = "<cr>", i = "<C-s>" },
						},
						close = {
							modes = { n = "q", i = "<C-c>" },
						},
					},
				},
				inline = { adapter = "gemini" },
			},

			adapter = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-2.5-flash-preview-04-17",
							},
						},
					})
				end,

				opts = { show_defaults = true },
			},
			opts = {
				language = "Chinese",
			},
		},
		config = true,
		dependencies = {
			{
				"echasnovski/mini.diff",
				config = function()
					local diff = require("mini.diff")
					diff.setup({
						view = {
							style = "sign",
							signs = {
								add = "▎",
								change = "▎",
								delete = "",
							},
						},
						source = diff.gen_source.none(),
					})

					for group, color in pairs(highlight) do
						vim.api.nvim_set_hl(0, group, color)
					end
				end,
			},
		},
	},
}
