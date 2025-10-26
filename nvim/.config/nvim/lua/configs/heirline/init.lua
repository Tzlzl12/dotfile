local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local colors = ""

if not vim.g.nvim_colorhelper == "" then
  colors = require(vim.g.nvim_colorhelper)
end
local function setup_colors()
  return {
    bg = colors.bg,
    fg = colors.fg,
    red = colors.red,
    orange = colors.orange,
    yellow = colors.yellow,
    green = colors.green,
    cyan = colors.cyan,
    blue = colors.blue,
    purple = colors.purple,
    white = colors.white,
    black = colors.black,
    gray = colors.gray,
    bright_bg = "None",
    bright_fg = utils.get_highlight("Folded").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    git_add = utils.get_highlight("diffAdded").fg,
    git_change = utils.get_highlight("diffChanged").fg,
    git_del = utils.get_highlight("diffDeleted").fg,
  }
end

vim.o.laststatus = 3
vim.o.showcmdloc = "statusline"
require("heirline").setup {
  statusline = require "configs.heirline.statusline",
  winbar = require "configs.heirline.winbar",
  tabline = require "configs.heirline.tabline",
  statuscolumn = require "configs.heirline.statuscolumn",

  opts = {
    disable_winbar_cb = function(args)
      if vim.bo[args.buf].filetype == "neo-tree" then
        return
      end
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive", "Trouble", "dashboard", "msg", "cmd", "pager", "dialog" },
      }, args.buf)
    end,
    colors = setup_colors,
  },
}

vim.o.statuscolumn = require("heirline").eval_statuscolumn()

vim.api.nvim_create_augroup("Heirline", { clear = true })

vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

-- vim.cmd("au BufWinEnter * if &bt != '' | setl stc= | endif")

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = "Heirline",
})
