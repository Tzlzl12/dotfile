local M = {}
local state = {
  show_hidden = false,
}

local uv = vim.uv
local sep = package.config:sub(1, 1)
local HOME = vim.env.HOME

-- -------------------------
-- 路径工具
-- -------------------------
local function join(...)
  return table.concat({ ... }, sep)
end

local function is_dir(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "directory"
end

local function is_file(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file"
end

-- -------------------------
-- workspace 计算
-- -------------------------
function M.workspace()
  -- 1. lsp root
  local buf = vim.api.nvim_get_current_buf()
  for _, client in pairs(vim.lsp.get_clients { bufnr = buf }) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- 2. 全局 workspace
  if vim.g.workspace and vim.fn.isdirectory(vim.g.workspace) == 1 then
    return vim.g.workspace
  end

  -- 3. cwd
  return uv.cwd()
end

-- -------------------------
-- 读取目录为 picker items
-- -------------------------

local function read_dir(dir)
  local items = {}
  local fd = uv.fs_scandir(dir)
  if not fd then
    return items
  end

  while true do
    local name, t = uv.fs_scandir_next(fd)
    if not name then
      break
    end

    -- 默认隐藏 . 开头
    if not state.show_hidden and name:sub(1, 1) == "." then
      goto continue
    end

    local full = join(dir, name)

    table.insert(items, {
      text = name,
      file = full, -- ⭐ Snacks 关键字段
      path = full, -- 你自己用，留着也没问题
      is_dir = (t == "directory"),
    })
    ::continue::
  end

  table.sort(items, function(a, b)
    if a.is_dir ~= b.is_dir then
      return a.is_dir
    end
    return a.text < b.text
  end)

  return items
end

-- -------------------------
-- 核心：打开 workspace picker
-- -------------------------
function M.open(dir)
  dir = dir or M.workspace()

  Snacks.picker {
    title = dir,
    cwd = dir,

    items = read_dir(dir),

    format = function(item)
      local icon = item.is_dir and "  " or "󰈔  "
      local icon_hl = item.is_dir and "Directory" or "Identifier"

      return {
        { icon, icon_hl },
        { item.text },
      }
    end,

    confirm = function(picker, item)
      if not item then
        return
      end

      if item.is_dir then
        vim.g.workspace = item.file
        vim.cmd("Neotree position=top dir=" .. vim.fn.fnameescape(item.file))
      else
        vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      end
      picker:close()
    end,
    win = {
      input = {
        keys = {
          ["<Right>"] = { "enter_dir", mode = { "n", "i" } },
          ["<Left>"] = { "parent_dir", mode = { "n", "i" } },
        },
      }, -- input
    }, -- win
    actions = {
      enter_dir = function(picker)
        require("utils.change_path").entry_path(picker)
      end,

      parent_dir = function(picker)
        require("utils.change_path").parent_dir(picker)
      end,
    },
  }
end

return M
