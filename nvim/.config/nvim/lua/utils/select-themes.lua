local M = {}
local colorscheme = require("utils.themes").colorscheme

-- 重新加载主题
local function reload_theme(name)
  colorscheme(name, false)
end

-- Picker 配置
M.title = "󱥚 Set Colorscheme"
M.preset = "vscode"
M.format = "text"

-- 获取所有可用的主题选项
M.finder = function()
  local items = {}

  if Ice and Ice.colorschemes then
    for family, config in pairs(Ice.colorschemes) do
      for key, actual_name in pairs(config.items) do
        table.insert(items, {
          text = key,
          family = family,
          actual_name = actual_name,
          background = key:match "^light-" and "light" or "dark",
        })
      end
    end
  end

  -- 可选：按家族名称排序
  table.sort(items, function(a, b)
    return a.text < b.text
  end)

  return items
end

M.on_change = function(picker, item)
  if item and item.text then
    reload_theme(item.text)
  end
end

M.preview = function(picker, item)
  return ""
end

M.confirm = function(picker, item)
  picker:close()

  if item and item.text then
    vim.schedule(function()
      reload_theme(item.text)

      -- 保存主题选择到缓存文件
      local colorscheme_cache = vim.fs.joinpath(vim.fn.stdpath "data", "colorscheme")
      local f = io.open(colorscheme_cache, "w")
      if f then
        f:write(item.text)
        f:close()
      end
    end)
  end
end

return M
