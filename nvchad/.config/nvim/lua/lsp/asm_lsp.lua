local M = {}
if not vim.g.nvchad_lsp.asm then
  M.defaults = function() end
  return M
end

M.defaults = function()
  vim.lsp.config("asm_lsp", {
    root_markers = { "CMakeLists.txt", "makefile", "build", ".git", ".nvim", ".ccls", ".ccls-cache" },
  })
  vim.lsp.enable "asm_lsp"
end

return M
