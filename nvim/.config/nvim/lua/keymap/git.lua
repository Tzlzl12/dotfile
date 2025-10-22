if vim.g.nvchad_use_telescope then
	local map = vim.keymap.set
	local prefix = "<leader>g"
	local tel = require("telescope.builtin")

	map("n", prefix .. "b", function()
		tel.git_branches()
	end, { desc = "Git Branches" })
	map("n", prefix .. "c", function()
		tel.git_commits()
	end, { desc = "Git Commits (repository)" })
	map("n", prefix .. "C", function()
		tel.git_bcommits()
	end, { desc = "Git Commits (current file)" })
	map("n", prefix .. "t", function()
		tel.git_status()
	end, { desc = "Git Status" })
	map("n", prefix .. "s", function()
		tel.git_stash()
	end, { desc = "Git Stash" })
end
