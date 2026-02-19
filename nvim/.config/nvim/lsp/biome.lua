return {
  cmd = { "biome", "lsp-proxy" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  ),
}
