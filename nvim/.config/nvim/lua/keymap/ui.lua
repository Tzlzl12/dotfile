local map = vim.keymap.set
local prefix = "<leader>u"

-- local tabline = require("chadrc").ui.tabline
map("n", prefix .. "g", ":Gitsigns toggle_current_line_blame<cr>", { desc = "UI Toggle Git Blame" })
-- map("n", prefix .. "a", function()
--   if require("copilot.client").is_disabled() then -- copilot is disable
--     require("copilot.command").enable()
--     require("codeium.api"):disable()
--   else
--     require("copilot.command").disable()
--     require("codeium.api"):enable()
--   end
-- end, { desc = "UI Toggle AI Inline" })
-- map("n", prefix .. "c", ":Fitten toggle_chat<cr>", { desc = "UI Toggle AI Chat" })

map("n", prefix .. "c", ":SmearCursorToggle<cr>", { desc = "UI Toggle Cursor" })

-- Git
local gitsigns = require("gitsigns")
map("n", prefix .. "g", "", { desc = "UI Git" })
map("n", prefix .. "gb", gitsigns.toggle_current_line_blame, { desc = "UI Toggle Git Line Blame" })
map("n", prefix .. "gw", gitsigns.toggle_word_diff, { desc = "UI Toggle Git Word Diff" })
map("n", prefix .. "gn", ":Gitsigns toggle_numhl<cr>", { desc = "UI Toggle Git Numhl" })
map("n", prefix .. "gh", ":Gitsigns toggle_linehl<cr>", { desc = "UI Toggle Git Linehl" })
-- Zen Mode
map("n", prefix .. "d", function()
	if vim.g.nvchad_ui_dim then
		Snacks.dim.disable()
		vim.g.nvchad_ui_dim = false
	else
		Snacks.dim.enable()
		vim.g.nvchad_ui_dim = true
	end
end, { desc = "UI Toggle Dim Inactive" })
map("n", prefix .. "z", function()
	Snacks.zen()
end, { desc = "UI Toggle Zen Mode" })
