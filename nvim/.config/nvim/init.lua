-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
Ice = {}
require "configs.env"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  { import = "plugins" },
}, {
  defaults = {
    lazy = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- 重置 packpath，减少扫描开销
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "man",
        "osc52",
        "spellfile",
      },
    },
  },
  -- 开启这个可以在 Lazy 界面看到更详细的加载信息
  profiling = {
    loader = true,
    require = true,
  },
})

require "configs.options"
--
vim.schedule(function()
  local rtp_plugin_path = vim.fs.joinpath(vim.opt.packpath:get()[1], "plugin")
  local dir = vim.uv.fs_scandir(rtp_plugin_path)
  if dir ~= nil then
    while true do
      local plugin, entry_type = vim.uv.fs_scandir_next(dir)
      if plugin == nil or entry_type == "directory" then
        break
      else
        vim.cmd(string.format("source %s/%s", rtp_plugin_path, plugin))
        -- vim.notify(string.format("source %s/%s", rtp_plugin_path, plugin))
      end
    end
  end
  local colorscheme_name = "dark-tokyonight" -- 默认主题
  local colorscheme_cache = vim.fs.joinpath(vim.fn.stdpath "data", "colorscheme")

  -- 尝试从缓存文件读取主题设置
  if vim.uv.fs_stat(colorscheme_cache) then
    local f = io.open(colorscheme_cache, "r")
    if f then
      local cached = vim.trim(f:read "*a")
      f:close()
      -- 验证缓存的主题是否仍然有效
      if require("utils.themes").get_colorscheme_config(cached) then
        colorscheme_name = cached
      end
    end
  end

  require("utils.themes").colorscheme(colorscheme_name, true)
end)
vim.schedule(function()
  require "configs.autocmd"
  require "configs.commands"
  require "configs.folding"
  require "keymap"
end)
