-- if vim.g.vscode then
--   require "vsc_conf"
-- else
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

require "utils.global_variable"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "syntax")
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")
dofile(vim.g.base46_cache .. "mason")
dofile(vim.g.base46_cache .. "git")
dofile(vim.g.base46_cache .. "tbline")
dofile(vim.g.base46_cache .. "nvcheatsheet")
dofile(vim.g.base46_cache .. "blankline")
dofile(vim.g.base46_cache .. "colors")

require "options"
require "nvchad.autocmds"
require "auto-commands"
require "lsp"
vim.schedule(function()
  require "mappings"
  require "keymaps.git"
  require "keymaps.ui"
  require "commands"
  require "configs.folding"
end)
-- end
