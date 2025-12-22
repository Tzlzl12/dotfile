local prefix = "<leader>u"
local map = vim.keymap.set

-- Git
local gitsigns = require "gitsigns"
map("n", prefix .. "g", "", { desc = "UI Git" })
map("n", prefix .. "gb", gitsigns.toggle_current_line_blame, { desc = "UI Toggle Git Line Blame" })
map("n", prefix .. "gw", gitsigns.toggle_word_diff, { desc = "UI Toggle Git Word Diff" })
map("n", prefix .. "gn", ":Gitsigns toggle_numhl<cr>", { desc = "UI Toggle Git Numhl" })
map("n", prefix .. "gh", ":Gitsigns toggle_linehl<cr>", { desc = "UI Toggle Git Linehl" })
