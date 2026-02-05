local M = {}

M.open_dir = function()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_delete(buf, { force = true })

  Snacks.picker.explorer {
    cwd = vim.env.HOME,
    layout = { preset = "default", size = { width = 0.9, height = 0.8 } },
  }
end

return M
