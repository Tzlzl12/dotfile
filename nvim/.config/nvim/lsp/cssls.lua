local root_markers = { ".git" }
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
  root_dir = vim.fs.dirname(
    vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  ),

  capabilities = {
    documentFormattingProvider = false,
    documentRangeFormattingProvider = false,
  },
}
