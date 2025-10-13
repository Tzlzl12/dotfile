local vscode = require "vscode"
local map = vim.keymap.set

map("n", "<tab>", "<Cmd>Tabnext<CR>")
map("n", "<s-tab>", "<Cmd>Tabprevious<CR>")
map(
  "n",
  "?",
  "<Cmd>lua require('vscode').action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })<CR>"
)
