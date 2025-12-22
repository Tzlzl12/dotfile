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
-- local root_dir = require("lspconfig").util.root_pattern("CMakeLists.txt", "build", ".clangd", ".git", ".nvim")
local init_options = {
  usePlaceholders = true,
  completeUnimported = true,
  clangdFileStatus = true,
}

return {
  -- capabilities = capabilities,
  filetypes = filetypes,
  cmd = cmd,
  keys = keys,
  support_single_file = true,
  init_options = init_options,
  root_markers = root_markers,
}
