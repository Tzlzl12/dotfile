return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
  workspace_required = false,
  root_dir = function(bufnr)
    return vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  end,
}
