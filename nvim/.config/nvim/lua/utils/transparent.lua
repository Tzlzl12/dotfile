local M = {}

M.transparent_toggle = function()
  vim.g.transparent_enable = not vim.g.transparent_enable

  local colorscheme = vim.g.nvim_colorscheme

  require("utils.themes").colorscheme(colorscheme, vim.g.transparent_enable)
end

return M
