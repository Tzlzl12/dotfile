if vim.g.lsp_clangd_loaded then
  return
end

vim.g.lsp_clangd_loaded = true

local config = require "lsp.configs.clangd"

vim.lsp.config("clangd", config)
vim.lsp.enable "clangd"

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Load clangd_extensions with clangd",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      require "clangd_extensions"
      -- vim.api.nvim_del_augroup_by_name "clangd_extensions" -- 删除自动组，避免重复加载
    end
  end,
})

-- 设置 clangd 的快捷键
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Load clangd_extension_mappings with clangd",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      -- 设置快捷键
      local opts = { buffer = args.buf }
      vim.keymap.set(
        "n",
        "<Leader>lh",
        "<Cmd>ClangdSwitchSourceHeader<CR>",
        { desc = "Switch source/header file", buffer = opts.buffer }
      )
    end
  end,
})

local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)

-- 检查是否已附加
if #vim.lsp.get_clients { bufnr = bufnr, name = "clangd" } > 0 then
  return
end

vim.lsp.start {
  name = "clangd",
  cmd = {
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
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_dir = vim.fs.dirname(filename),
  single_file_support = true,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
