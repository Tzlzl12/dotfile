local root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" }
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },

  -- root_dir = require("lspconfig.util").root_pattern(unpack(root_markers)),
  -- root_dir = vim.fs.dirname(
  --   vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
  -- -- or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  -- ),

  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
}
