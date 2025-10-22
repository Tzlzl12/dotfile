local map = vim.keymap.set

local lsp_action
if vim.g.nvchad_use_telescope then
	lsp_action = require("telescope.builtin")
else
	lsp_action = Snacks.picker
end
local prefix = "<leader>l"
map("n", "<leader>ra", vim.lsp.buf.rename, { desc = "Lsp NvRenamer" })
--
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Lsp Code action" })
map("n", prefix .. "h", function()
	return vim.lsp.buf.hover()
end, { desc = "Lsp Hover" })
map("n", "<leader>cd", function()
	vim.diagnostic.open_float({
		border = "rounded", -- 或者其他边框样式
	})
end, { remap = true, desc = "Lsp Hover Diagnostic" })
map("n", prefix .. "r", function()
	lsp_action.lsp_references()
end, { remap = true, desc = "LSP References" })
map("n", prefix .. "s", function()
	if vim.g.nvchad_use_telescope then
		lsp_action.lsp_document_symbols()
	else
		lsp_action.lsp_symbols({ preset = "sidebar", layout = { position = "right" } })
	end
end, { remap = true, desc = "Lsp Symbols (Buffer)" })
map("n", prefix .. "S", function()
	if vim.g.nvchad_use_telescope then
		lsp_action.lsp_workspace_symbols()
	else
		lsp_action.lsp_workspace_symbols({ preset = "sidebar", layout = { position = "right" } })
	end
end, { remap = true, desc = "Lsp Symbols (WorkSpace)" })
map("n", prefix .. "D", function()
	lsp_action.diagnostics()
end, { remap = true, desc = "Lsp Hover Diagnostic(WorkSpace)" })
map("n", prefix .. "i", function()
	lsp_action.lsp_implementations()
end, { remap = true, desc = "Lsp Implementations" })
map("n", prefix .. "d", function()
	lsp_action.lsp_definitions()
end, { remap = true, desc = "Lsp Goto Definition" })
map("n", prefix .. "y", function()
	lsp_action.lsp_type_definitions()
end, { remap = true, desc = "Lsp Goto TypeDefinition" })
