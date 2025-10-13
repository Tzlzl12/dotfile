local M = {}
-- local fitten = require "fittencode"
-- fitten.translate_text()
-- fitten.translate_text_into_chinese()
M.fanyi = function()
  local function splitString(input)
    local result = {}
    local current = ""

    for i = 1, #input do
      local ch = input:sub(i, i)

      -- 如果是大写字母，并且不是字符串的第一个字符
      if ch:match "%u" and i ~= 1 then
        -- 将当前段加入结果数组
        if current ~= "" then
          table.insert(result, current)
          current = ""
        end
      end

      -- 如果是下划线
      if ch == "_" then
        -- 将当前段加入结果数组
        if current ~= "" then
          table.insert(result, current)
          current = ""
        end
      else
        -- 将字符加入当前段
        current = current .. ch:lower()
      end
    end

    -- 添加最后一段
    if current ~= "" then
      table.insert(result, current)
    end

    return result
  end
  local get_word = vim.fn.expand "<cword>"
  local words = splitString(get_word)

  local result = "" -- 用于存储最终结果
  local completed = 0 -- 用于跟踪完成的进程数量

  if vim.fn.executable "trans" == 0 then
    vim.notify("Please make sure `trans` in your PATH", vim.log.levels.INFO)
    return
  end

  for i = 1, #words do
    -- 创建一个管道用于读取 stdout
    local word = words[i]
    local stdout = vim.loop.new_pipe(false)

    -- 启动外部进程
    local handle, pid = vim.loop.spawn("trans", {
      args = { words[i] }, -- 命令参数
      stdio = { nil, stdout, nil }, -- 只捕获 stdout
    }, function(code, signal) -- 进程退出回调
      stdout:read_stop()
      stdout:close()
      completed = completed + 1

      -- 检查是否所有进程都已完成
      if completed == #words then
        result = string.sub(result, 1, -2)
        vim.notify(result, vim.log.levels.WARN, {
          title = " Translate ",
          icon = "󰊿 ",
        })
        -- vim.notify(result, vim.log.levels.WARN)
      end
    end)

    -- 读取 stdout 数据
    stdout:read_start(function(err, data)
      if data then
        result = result .. "**" .. word .. "**" .. ":" .. data
      end
    end)
  end
end

M.fanyi_ch_to_en = function()
  vim.ui.input({ prompt = "Translate the Word" }, function(input)
    local opt = ""
    local timeout = 5000
    local async_trans = function(option, flag)
      vim.system({ "trans", option, input }, { text = true }, function(res)
        local result = string.sub(res.stdout, 1, -2)
        if flag then
          ---@diagnostic disable-next-line: cast-local-type
          timeout = false
        end
        vim.notify(result, vim.log.levels.WARN, {
          title = " Translate ",
          icon = "󰊿 ",
          timeout = timeout,
        })
        -- vim.notify(resulr, vim.log.levels.WARN)
      end)
    end
    if input then
      if input:match "^[A-Za-z]+$" then
        opt = "en:zh"
        async_trans(opt, false)
      else
        opt = "zh-CN:en" -- 中文转英语
        async_trans(opt, true)
      end
    end
  end)
end
return M
