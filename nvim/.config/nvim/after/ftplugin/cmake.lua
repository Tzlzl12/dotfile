if vim.g.lsp_neocmake_loaded then
  return
end

vim.g.lsp_neocmake_loaded = true

vim.lsp.config("neocmake", {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },
  root_markers = { ".git", "build", "cmake" },
})

vim.lsp.enable "neocmake"
