local highlights = { -- Gitsigns
	GitSignsAdd = { bg = "NONE", fg = "#40a02b" },
	GitSignsChange = { bg = "NONE", fg = "#df8e1d" },
	GitSignsDelete = { bg = "NONE", fg = "#d20f39" },
	GitSignsAddLn = { bg = "#dee8e0", fg = "NONE" },
	GitSignsChangeLn = { bg = "#ebd9bf", fg = "NONE" },
	GitSignsDeleteLn = { bg = "#ecdae2", fg = "NONE" },
	-- 单词级高亮 gitsigns
	GitSignsAddInline = { bg = "#c3ddc3", fg = "NONE" },
	GitSignsChangeInline = { bg = "#ebd9bf", fg = "NONE" },
	GitSignsDeleteInline = { bg = "#e8b9c6", fg = "NONE" },
	GitSignsAddPreview = { bg = "#40a02b", fg = "#282828" },
	GitSignsDeletePreview = { bg = "#d20f39", fg = "#282828" },
}

return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre" },
		opts = {
			current_line_blame = true, --  启用 Git blame
			current_line_blame_opts = {
				virt_text = true, -- 在当前行显示提交信息
				virt_text_pos = "eol", -- 显示在行尾
				delay = 500, -- 延迟显示（单位 ms）
			},
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "┆ " },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "┆" },
			},
			on_attach = function(buffer)
				for group, colors in pairs(highlights) do
					vim.api.nvim_set_hl(0, group, colors)
				end
				require("keymap.git")
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end
				map("n", "q", function()
					if vim.wo.diff then
						-- 记住当前窗口
						local current_win = vim.api.nvim_get_current_win()
						-- 遍历所有窗口
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							-- 如果不是当前窗口且是 diff 模式
							if win ~= current_win and vim.wo[win].diff then
								-- 关闭另一个 diff 窗口
								vim.cmd(vim.api.nvim_win_get_number(win) .. "wincmd c")
								-- 关闭当前窗口的 diff 模式
								vim.cmd("diffoff")
								return
							end
						end
					end
				end, "Git Quit Diff")
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Jump Git Next Hunk")
				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Jump Git Prev Hunk")
				map("n", "]H", function()
					gs.nav_hunk("last")
				end, "Jump Git Last Hunk")
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, "Jump Git First Hunk")
				map({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", "Git Stage/Unstage Hunk")
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Git Reset Hunk")
				map("n", "<leader>gA", gs.stage_buffer, "Git Stage Buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Git Undo Stage Hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Git Reset Buffer")
				map("n", "<leader>gp", gs.preview_hunk_inline, "Git Preview Hunk Inline")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Git Blame Line")
				map("n", "<leader>ghB", function()
					gs.blame()
				end, "Git Blame Buffer")
				if vim.g.nvchad_use_telescope then
					map("n", "<leader>gd", gs.diffthis, "Git Diff This")
				end
				-- map("n", "<leader>gD", function()
				--   gs.diffthis "~"
				-- end, "Git Diff This ~")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git Signs Select Hunk")
			end,
		},
	},
}
