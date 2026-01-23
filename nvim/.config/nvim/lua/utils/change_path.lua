local M = {}

M.parent_dir = function(picker)
  local ok, cwd = pcall(function()
    return picker:cwd()
  end)

  if not ok or not cwd then
    return
  end

  -- HOME 作为根，不能再往上
  if cwd == vim.env.HOME then
    return
  end

  local parent = vim.fn.fnamemodify(cwd, ":h")
  if not parent or parent == cwd then
    return
  end

  picker:close()

  vim.schedule(function()
    vim.g.workspace = parent
    require("utils.workspace").open(parent)
  end)
end

M.entry_path = function(picker)
  local item = picker:current()
  if not item or not item.is_dir then
    return
  end

  local dir = item.file
  picker:close()

  vim.schedule(function()
    vim.g.workspace = dir
    require("utils.workspace").open(dir)
  end)
end

return M
