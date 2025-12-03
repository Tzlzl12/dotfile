local prefix = "<leader>g"
local map = vim.keymap.set
if vim.g.nvchad_use_telescope then
  local tel = require "telescope.builtin"

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

-- Git
local gitsigns = require "gitsigns"
map("n", prefix .. "g", "", { desc = "UI Git" })
map("n", prefix .. "gb", gitsigns.toggle_current_line_blame, { desc = "UI Toggle Git Line Blame" })
map("n", prefix .. "gw", gitsigns.toggle_word_diff, { desc = "UI Toggle Git Word Diff" })
map("n", prefix .. "gn", ":Gitsigns toggle_numhl<cr>", { desc = "UI Toggle Git Numhl" })
map("n", prefix .. "gh", ":Gitsigns toggle_linehl<cr>", { desc = "UI Toggle Git Linehl" })
