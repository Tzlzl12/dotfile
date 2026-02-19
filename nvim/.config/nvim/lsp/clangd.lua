-- local nv_lsp = require "lsp.default_config"
local cmd = {
  "clangd",
  "--log=verbose",
  "--pretty",
  "--all-scopes-completion",
  "--completion-style=bundled",
  "--cross-file-rename",
  "--header-insertion=never",
  "--header-insertion-decorators",
  "--background-index",
  "-j=2",
  "--pch-storage=disk",
  "--function-arg-placeholders=false",
  "--compile-commands-dir=./build",
}
local filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
local root_markers =
  { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" }
local keys = {
  { "<leader>lh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
}
local init_options = {
  usePlaceholders = true,
  completeUnimported = true,
  clangdFileStatus = true,
}

return {
  filetypes = filetypes,
  cmd = cmd,
  keys = keys,
  support_single_file = true,
  init_options = init_options,
  root_dir = vim.fs.dirname(
    vim.fs.find(root_markers, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
      or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- support for single file
  ),

  -- root_markers = root_markers,
}
