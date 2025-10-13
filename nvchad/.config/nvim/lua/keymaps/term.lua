local map = vim.keymap.set
local prefix = "<leader>T"

-- 使用 snacks.nvim 的终端功能
local Snacks = require "snacks"

local find_git_root = require("utils").find_git_root

-- 执行命令的函数
local exec = function(cmd)
  local term_width = math.floor(vim.o.columns * 0.35)
  term_width = term_width > 35 and term_width or 35

  -- 使用 snacks.nvim 创建浮动终端
  Snacks.terminal.open(cmd, {
    win = {
      position = "float",
      border = "double",
      size = { width = term_width },
    },
    auto_close = true,
  })

  -- 发送命令到终端
  -- vim.api.nvim_chan_send(vim.b[term.buf].terminal_job_id, cmd .. "\n")
end

-- 切换终端显示
local term_toggle = function()
  -- 获取所有终端
  local terminals = Snacks.terminal.list()

  -- 检查是否有打开的终端
  for _, term in ipairs(terminals) do
    if term:buf_valid() and term:win_valid() then
      term:hide()
      return
    end
  end

  -- 获取当前目录
  local current_dir = require("utils").get_root_dir()

  -- 打开或创建一个终端
  local term, _ = Snacks.terminal.get(nil, {
    cwd = current_dir,
    win = {
      position = "float",
      border = "double",
    },
    interactive = true,
  })

  if term then
    term:show()
  end
  -- 聚焦到终端窗口并进入插入模式
  vim.schedule(function()
    vim.cmd "startinsert!"
  end)
end

-- 从终端模式切换终端显示
local term_toggle_t = function()
  -- 获取所有终端
  local terminals = Snacks.terminal.list()

  -- 检查是否有打开的终端
  for _, term in ipairs(terminals) do
    if term:buf_valid() and term:win_valid() then
      term:hide()
      return
    end
  end

  -- 尝试找到并打开之前创建的终端
  local term = terminals[1]
  if term then
    term:show()
  end
end

-- 普通模式下的终端切换键绑定
map("n", "<C-Space>", function()
  term_toggle()
end, { desc = "General Toggle Terminal" })

-- 终端模式下的终端切换键绑定
map("t", "<c-space>", function()
  term_toggle_t()
end, { desc = "General Toggle Terminal" })

-- 编译运行快捷键
map("n", "<leader>rc", function()
  local ret = require("keymaps.compiler").get_compiler()
  if ret == nil then
    print "This file type is not support"
    return
  end
  local cmd = require("keymaps.compiler").compile(ret[1], ret[2])
  exec(cmd)
end, { desc = "General Task Run" })

-- 终端管理器（需要使用替代方案，因为 snacks.nvim 没有直接的 Telescope 集成）
map("n", "<leader>fm", function() end, { desc = "List Terminals" })

-- 创建浮动终端（Node.js）
map("n", prefix .. "n", function()
  Snacks.terminal.open("node", {
    win = {
      position = "float",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Node" })

-- 创建浮动终端（Python）
map("n", prefix .. "p", function()
  Snacks.terminal.open("python", {
    win = {
      position = "float",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Python" })

-- Git 终端
map("n", "<leader>gg", function()
  local git = ""
  if vim.fn.executable "gitui" == 1 then
    git = "gitui"
  elseif vim.fn.executable "lazygit" == 1 then
    git = "lazygit"
  else
    print "not found any git tui, such as `lazygit` or `gitui`"
    return
  end

  Snacks.terminal.open(git, {
    cwd = find_git_root(), -- 这里假设 git_dir 是一个可用的变量或字符串
    win = {
      position = "float",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Git" })

-- 创建浮动终端（Bottom 监控工具）
map("n", prefix .. "t", function()
  Snacks.terminal.open("btop", {
    win = {
      position = "float",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Btm" })

-- 创建水平终端
map({ "n", "t" }, prefix .. "h", function()
  Snacks.terminal.open(nil, {
    win = {
      position = "bottom",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Horizontal" })

-- 创建垂直终端
map({ "n", "t" }, prefix .. "v", function()
  Snacks.terminal.open(nil, {
    win = {
      position = "right",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal Vertical" })

-- 创建一个新的水平终端
map("n", prefix .. "a", function()
  Snacks.terminal.open(nil, {
    win = {
      position = "bottom",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal New" })
map("n", "<c-i>", function()
  Snacks.terminal.open(nil, {
    win = {
      position = "bottom",
      border = "double",
    },
    auto_close = true,
  })
end, { desc = "Terminal New" })
