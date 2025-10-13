local M = {}
local count = 0

local function reload_theme(name)
  require("nvconfig").base46.theme = name
  require("base46").load_all_highlights()
end

M.title = "󱥚 Set NvChad Theme"
M.preset = "vscode"
M.format = "text"

M.finder = function()
  -- 使用 NvChad 的主题列表而不是 vim colorschemes
  local themes = require("nvchad.utils").list_themes()
  local items = {}
  for _, theme in ipairs(themes) do
    table.insert(items, { text = theme })
  end
  return items
end

M.on_change = function(picker, item)
  count = count + 1
  -- reload theme while typing
  vim.schedule(function()
    vim.api.nvim_create_autocmd("TextChangedI", {
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        if item and item.text then
          reload_theme(item.text)
        end
      end,
    })
  end)
  if count < 3 then
    return
  else
    if item and item.text then
      reload_theme(item.text)
    end
  end
end
M.preview = function(picker, item)
  return ""
end

M.confirm = function(picker, item)
  picker:close()
  if item and item.text then
    -- 清除预览状态
    if picker.preview and picker.preview.state then
      picker.preview.state.colorscheme = nil
    end
    vim.schedule(function()
      reload_theme(item.text)
      -- 保存主题到 chadrc 配置文件
      package.loaded.chadrc = nil
      local old_theme = require("chadrc").base46.theme
      old_theme = '"' .. old_theme .. '"'
      local theme = '"' .. item.text .. '"'
      -- 替换配置文件中的主题设置
      require("nvchad.utils").replace_word(old_theme, theme)
    end)
  end
end

return M
