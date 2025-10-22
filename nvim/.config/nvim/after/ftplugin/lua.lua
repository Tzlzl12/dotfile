local config = require("lsp.configs.lua")

vim.lsp.config("lua_ls", config)
vim.lsp.enable("lua_ls")
