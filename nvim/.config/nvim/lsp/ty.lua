local root_markers =
  { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" }

return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = vim.fs.dirname(
    vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  ),

  -- root_markers = root_markers,
  settings = {
    ty = {},
  },
}
