local map = vim.keymap.set

local lsp_action
if vim.g.nvchad_use_telescope then
  lsp_action = require "telescope.builtin"
else
  lsp_action = Snacks.picker
end
local prefix = "g"

map("n", prefix .. "h", function()
  return vim.lsp.buf.hover()
end, { desc = "Lsp Hover" })
map("n", prefix .. "r", function()
  lsp_action.lsp_references()
end, { desc = "LSP References", remap = true })
map("n", prefix .. "s", function()
  lsp_action.lsp_document_symbols()
end, { desc = "Lsp Symbols (Buffer)" })
-- map("n", prefix .. "S", function()
--   tel.lsp_workspace_symbols()
-- end, { desc = "Lsp Symbols (WorkSpace)" })
-- map("n", prefix .. "D", function()
--   tel.diagnostics()
-- end, { desc = "Lsp Hover Diagnostic(WorkSpace)" })
map("n", prefix .. "i", function()
  lsp_action.lsp_implementations()
end, { desc = "Lsp Implementations" })
map("n", prefix .. "d", function()
  lsp_action.lsp_definitions()
end, { desc = "Lsp Goto Definition", remap = true })
map("n", prefix .. "y", function()
  lsp_action.lsp_type_definitions()
end, { desc = "Lsp Goto TypeDefinition", remap = true })
