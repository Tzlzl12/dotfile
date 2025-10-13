local fanyi = function()
  -- 分割单词的函数
  local function splitWords(word)
    local words_array = {}

    -- 判断并分割大驼峰命名（PascalCase）
    if word:match "^%u%l*%u%l*$" then
      for part in word:gmatch "%u%l*" do
        table.insert(words_array, part:lower()) -- 转为小写
      end
    -- 判断并分割小驼峰命名（camelCase）
    elseif word:match "^[%l]%u" then
      for part in word:gmatch "[%l%u][%l]*" do
        table.insert(words_array, part:lower()) -- 转为小写
      end
      -- 判断并分割蛇形命名（snake_case）
    elseif word:match "^[%l_]+$" then
      for part in word:gmatch "([^_]+)" do
        table.insert(words_array, part) -- 蛇形命名不转小写
      end
    end

    return words_array
  end
  -- 定义一个函数来提取word的解释
  local function extractDefinitions(text)
    -- 搜索以"- adj."、"- adv."、"- n."、"- vt."和"- vi."开头的行，并提取解释部分
    local patterns = {
      "^%s*%- adj%. (.+)$", -- 匹配以 - adj. 开头的行
      "^%s*%- adv%. (.+)$", -- 匹配以 - adv. 开头的行
      "^%s*%- n%. (.+)$", -- 匹配以 - n. 开头的行
      "^%s*%- vt%. (.+)$", -- 匹配以 - vt. 开头的行
      "^%s*%- vi%. (.+)$", -- 匹配以 - vi. 开头的行
    }

    local definitions = {} -- 用于存储匹配到的解释的字符串数组
    for line in text:gmatch "[^\n]+" do
      for _, pattern in ipairs(patterns) do
        local match = line:match(pattern)
        if match then
          -- 将匹配的前缀和解释部分组合成一个字符串
          local prefix = line:match "^(%s*%-%s%w+%.%s)"
          table.insert(definitions, prefix .. match .. " ") -- 加入前缀和一个空格
          break -- 找到匹配项后不再检查其他模式
        end
      end
    end

    return definitions -- 返回字符串数组
  end

  local popup = require "nui.popup"

  local get_word = vim.fn.expand "<cword>"
  local words = splitWords(get_word)

  -- 设置高亮组以定义背景颜色
  -- local colors = require("tokyonight.colors").setup()
  -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue, bg = colors.bg }) -- 边框颜色
  -- vim.api.nvim_set_hl(0, "PopupTitle", { bg = colors.bg }) -- 顶部文本颜色
  -- 创建一个显示简单文本的浮动窗口的函数
  local popup_window = popup {
    position = {
      row = "50%", -- 垂直居中
      col = "50%", -- 水平居中
    },
    size = {
      width = 40, -- 窗口宽度
      height = 25, -- 窗口高度
    },
    border = {
      style = "rounded", -- 边框样式
      text = {
        top = " 󰊿Trans ", -- 顶部标题
        top_align = "center", -- 对齐方式
      },
    },
    buf_options = {
      modifiable = true, -- 允许修改
      readonly = false, -- 允许修改
    },
    win_options = {
      winblend = 10, -- 透明度
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder", -- 高亮组
    },
  }

  -- 挂载窗口
  popup_window:mount()

  local lines = {}

  for _, word in ipairs(words) do
    local result = vim.fn.system { "fanyi", word }
    local definition_lines = extractDefinitions(result)
    local entry = word .. ":" -- 词汇后加冒号并换行
    table.insert(lines, entry) -- 添加词汇行

    for _, definition in ipairs(definition_lines) do
      table.insert(lines, definition) -- 添加定义
    end

    table.insert(lines, "") -- 在每个词汇的定义后添加空行，方便分隔
  end

  -- 设置窗口的内容
  if #lines > 0 then
    -- local header = words[1] .. ":" -- 只取第一个单词作为头部
    -- vim.api.nvim_buf_set_lines(popup_window.bufnr, 0, -1, false, { header, "" }) -- 第一行是单词和冒号，第二行空行
    vim.api.nvim_buf_set_lines(popup_window.bufnr, 0, -1, false, lines) -- 从第三行开始设置定义
  else
    vim.api.nvim_buf_set_lines(popup_window.bufnr, 0, -1, false, { "未找到相关定义。" })
  end

  -- 监听光标移动事件以在光标移动时关闭窗口
  vim.api.nvim_create_autocmd("CursorMoved", {
    once = true,
    callback = function()
      popup_window:unmount() -- 关闭窗口
    end,
  })
end
return fanyi
