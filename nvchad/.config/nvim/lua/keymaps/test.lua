-- 查找 Git 仓库根目录的函数
-- 从当前工作目录开始，向上级目录查找，直到找到包含 .git 文件夹的目录
-- @return string|nil 找到的 Git 仓库根目录路径，如果未找到则返回 nil
local function find_git_root()
  local dirs = ""
  local current_dir = require("utils").get_root_dir()
  if current_dir == "" then
    return nil
  end

  -- 规范化路径（处理`../`等相对路径）
  current_dir = vim.fn.fnamemodify(current_dir, ":p")

  -- 从当前目录开始向上查找
  while current_dir ~= "/" do
    local git_dir = current_dir .. "/.git"

    -- 检查.git是否存在（可以是文件或目录）
    dirs = dirs .. current_dir .. " "
    if vim.fn.isdirectory(git_dir) == 1 or vim.fn.filereadable(git_dir) == 1 then
      return current_dir
    end

    -- 向上级目录移动
    local parent = vim.fn.fnamemodify(current_dir, ":h")
    if parent == current_dir then -- 到达根目录
      break
    end
    current_dir = parent
  end

  print(dirs)
  return nil
end

return find_git_root
