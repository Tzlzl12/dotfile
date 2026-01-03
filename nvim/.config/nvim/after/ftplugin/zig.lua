if vim.g.lsp_zig_loaded then
  return
end

vim.g.lsp_zig_loaded = true
vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git", "build.zig.zon" },
  workspace_required = false,
})
vim.lsp.enable "zls"
