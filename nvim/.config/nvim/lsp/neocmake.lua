local root_markers = { ".git", "build", "cmake", "CMakeLists.txt" }
return {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },
  -- root_dir = vim.fs.dirname(
  --   vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
  --     or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  -- ),

  root_markers = root_markers,
}
