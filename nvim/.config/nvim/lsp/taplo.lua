local root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", "pyproject.toml", ".git" }
return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = vim.fs.dirname(
    vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  ),

  -- root_markers = ,
}
