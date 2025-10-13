-- 解析YAML字符串

local function parseYaml(input)
  local result = {}

  -- 检查输入是否为空
  if not input or input == "" then
    return result
  end

  local currentTable = result
  local tableStack = {}
  local currentIndent = 0
  local lastKey = nil

  -- 逐行解析输入
  for line in input:gmatch "[^\r\n]+" do
    -- 跳过纯注释行和空行
    if not line:match "^%s*#" and line:match "%S" then
      -- 计算缩进级别
      local indent = line:match("^(%s*)"):len()
      local content = line:match "^%s*(.*)"

      -- 文档分隔符，忽略
      if content:match "^%-%-%-" then
        content = content:gsub("^%-%-%-", ""):match "^%s*(.*)"
      end

      -- 处理键值对: "key: value" 或 "key:"
      local key, value = content:match "^([^:]+):%s*(.*)"

      if key then
        key = key:match "^%s*(.-)%s*$" -- 去除首尾空格
        value = value:match "^%s*(.-)%s*$" -- 去除首尾空格

        -- 根据缩进调整当前表
        if indent < currentIndent then
          local levels = (currentIndent - indent) / 2
          for i = 1, levels do
            table.remove(tableStack)
          end
          if #tableStack > 0 then
            currentTable = tableStack[#tableStack]
          else
            currentTable = result
          end
        end

        -- 处理不同类型的值
        if value == "" then
          -- 空值表示这是一个新表
          currentTable[key] = {}
          table.insert(tableStack, currentTable)
          currentTable = currentTable[key]
          lastKey = key
        elseif value:match "^%[" then
          -- 数组开始
          currentTable[key] = {}
          table.insert(tableStack, currentTable)
          currentTable = currentTable[key]
          lastKey = key
        else
          -- 正常的键值对
          -- 尝试转换数值类型
          if value:match "^%d+$" then
            value = tonumber(value)
          elseif value:match "^%d+%.%d+$" then
            value = tonumber(value)
          elseif value == "true" then
            value = true
          elseif value == "false" then
            value = false
          end
          currentTable[key] = value
          lastKey = key
        end

        currentIndent = indent
      else
        -- 处理列表项 "- item"
        local item = content:match "^%s*%-%s*(.*)"
        if item then
          item = item:match "^%s*(.-)%s*$" -- 去除首尾空格

          -- 尝试转换数值类型
          if item:match "^%d+$" then
            item = tonumber(item)
          elseif item:match "^%d+%.%d+$" then
            item = tonumber(item)
          elseif item == "true" then
            item = true
          elseif item == "false" then
            item = false
          end

          -- 确保当前表是数组
          if type(currentTable) ~= "table" then
            currentTable = {}
            if lastKey then
              tableStack[#tableStack][lastKey] = currentTable
            else
              result = currentTable
            end
          end

          table.insert(currentTable, item)
        end
      end
    end
  end

  return result
end

-- 从文件读取并解析YAML
return function(filename)
  local file = io.open(filename, "r")
  if not file then
    vim.notify("no " .. filename .. "found")
    return
  end

  local yaml_content = file:read "*a" -- 读取文件所有内容
  vim.notify("find", 1)
  file:close()

  return parseYaml(yaml_content)
end
