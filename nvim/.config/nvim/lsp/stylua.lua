return {
  cmd = { "stylua", "--lsp" },
  filetypes = { "lua", "luau" },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "stylua.toml", ".stylua.toml" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  ),
}
