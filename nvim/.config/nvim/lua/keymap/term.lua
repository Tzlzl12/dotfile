local map = vim.keymap.set
local prefix = "<leader>T"

-- --- 核心 Toggle 逻辑 ---
-- Snacks.terminal.toggle 会自动管理实例，如果已打开则关闭，如果关闭则打开
local term_toggle = function()
  Snacks.terminal.toggle(nil, {
    win = {
      position = "float",
      border = "double",
    },
    cwd = require("utils").get_root_dir(), -- 保持你原本的 root 逻辑
  })
end

-- --- 快捷键映射 ---

-- 普通模式与终端模式下的 Toggle
map({ "n", "t" }, "<C-Space>", term_toggle, { desc = "Terminal Toggle" })
map({ "n", "t" }, "<c-`>", term_toggle, { desc = "Terminal Toggle" })
-- map("n", "`", term_toggle, { desc = "Terminal Toggle", remap = true })
-- map("t", "`", term_toggle, { desc = "Terminal Toggle" })

-- --- 专项浮动终端 ---

-- Git (优先使用 snacks 内置的集成)
-- Gitui 专项配置
map("n", "<leader>gg", function()
  -- 检查 gitui 是否安装
  if vim.fn.executable "gitui" ~= 1 then
    vim.notify("not found `gitui` in your `PATH`", vim.log.levels.ERROR)
    return
  end

  Snacks.terminal.open("gitui", {
    win = {
      title = " Gitui ",
      border = "double",
      -- 设置窗口大小，gitui 通常需要大一点的视野
      width = 0.9,
      height = 0.9,
    },
    -- 确保在项目的根目录下打开
    cwd = require("utils").get_root_dir(),
  })
end, { desc = "Terminal Gitui" })

-- Node
map("n", prefix .. "n", function()
  Snacks.terminal.open("node", { win = { title = " Node ", border = "double" } })
end, { desc = "Terminal Node" })

-- Python
map("n", prefix .. "p", function()
  Snacks.terminal.open("python", { win = { title = " Python ", border = "double" } })
end, { desc = "Terminal Python" })

-- Btop (监控)
map("n", prefix .. "t", function()
  Snacks.terminal.open("btop", { win = { title = " Btop ", border = "double" } })
end, { desc = "Terminal Btop" })

-- --- 布局控制 ---

-- 水平拆分终端
map({ "n", "t" }, prefix .. "h", function()
  Snacks.terminal.open(nil, { win = { position = "bottom" } })
end, { desc = "Terminal Horizontal" })

-- 垂直拆分终端
map({ "n", "t" }, prefix .. "v", function()
  Snacks.terminal.open(nil, { win = { position = "right" } })
end, { desc = "Terminal Vertical" })

-- 创建新终端 (Snacks 默认 open 就会创建一个新实例)
map("n", prefix .. "a", function()
  Snacks.terminal.open(nil, { win = { position = "float", border = "double" } })
end, { desc = "Terminal New" })

-- Terminal Manager (Snacks Picker 已经集成了终端管理)
map("n", "<leader>fm", function()
  Snacks.picker.terminal()
end, { desc = "Picker Terminal" })
