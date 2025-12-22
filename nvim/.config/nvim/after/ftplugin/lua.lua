if vim.g.lsp_luals_loaded then
  return
end

vim.g.lsp_luals_loaded = true
local config = require "lsp.configs.lua"

vim.lsp.config("lua_ls", config)
vim.lsp.enable "lua_ls"
