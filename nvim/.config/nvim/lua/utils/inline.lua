local M = {}

M.inlint_toggle = function()
  if vim.g.use_copilot then
    require("neocodeium.commands").enable()
    require("copilot.command").disable()
    vim.notify("use `codeium`", vim.log.levels.INFO)
    vim.g.use_copilot = false
  else
    require("neocodeium.commands").disable()
    require("copilot.command").enable()
    vim.notify("use `copilot`", vim.log.levels.INFO)
    vim.g.use_copilot = true
  end
end

return M
