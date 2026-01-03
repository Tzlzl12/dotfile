vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

if vim.g.lsp_python_loaded then
  return
end

vim.g.lsp_python_loaded = true
local lsp_name = "ty"

local config = require("lsp.configs." .. lsp_name)

vim.lsp.config(lsp_name, config)
vim.lsp.enable(lsp_name)

vim.lsp.config("ruff", {
  name = "ruff",
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})
vim.lsp.enable "ruff"

-- single file support
local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)

-- 检查是否已附加
if vim.lsp.is_enabled "pyright" or vim.lsp.is_enabled "ty" or vim.lsp.is_enabled "ruff" then
  return
end

if lsp_name == "pyright" then
  vim.lsp.start {
    name = "pyright",
    cmd = { "pyright-langserver", "--stdio" },
    root_dir = vim.fs.dirname(filename),
    single_file_support = true, -- 明确启用单文件支持
    settings = {
      python = {
        pythonPath = "python",
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly", -- 只检查打开的文件
        },
      },
    },
  }
elseif lsp_name == "ty" then
  vim.lsp.start {
    name = "ty",
    cmd = { "ty", "server" },
    root_dir = vim.fs.dirname(filename),
    single_file_support = true, -- 明确启用单文件支持
  }
end

vim.lsp.start {
  name = "ruff",
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = vim.fs.dirname(filename),
  single_file_support = true,
}
