local colorscheme = {}

local original_theme = vim.g.nvim_colorscheme
local preview_timer = nil
local confirmed = false

local function get_base16(theme)
  return require("base46.utils").get_theme_tb("base_16", theme)
end

local function ensure_base16_hls(theme)
  local ok, base16 = pcall(get_base16, theme)
  if not ok or not base16 then
    return
  end
  local safe_name = theme:gsub("[^%w]", "_")
  for i = 0, 15 do
    local key = string.format("base%02X", i)
    local color = base16[key]
    if color then
      vim.api.nvim_set_hl(0, "SnacksThemeBlock_" .. safe_name .. "_" .. key, { fg = color })
    end
  end
end

colorscheme.format = function(item)
  if not item or not item.text then
    return {}
  end
  local theme = item.text
  ensure_base16_hls(theme)
  local safe_name = theme:gsub("[^%w]", "_")
  local chunks = {}
  chunks[#chunks + 1] = { string.format("%-24s", theme), "Normal" }
  local ok, base16 = pcall(get_base16, theme)
  if ok and base16 then
    for i = 0, 15 do
      local key = string.format("base%02X", i)
      if base16[key] then
        chunks[#chunks + 1] = { "󱓻 ", "SnacksThemeBlock_" .. safe_name .. "_" .. key }
      end
    end
  end
  return chunks
end

colorscheme.finder = function()
  local items = {}
  local ok, themes = pcall(function()
    return require("base46").list_themes()
  end)
  if not ok or not themes then
    return {}
  end
  for _, theme in ipairs(themes) do
    items[#items + 1] = { text = theme }
  end
  table.sort(items, function(a, b)
    return a.text < b.text
  end)
  return items
end

local function reload_theme(name)
  require("base46.utils").change_cached_theme(name)
  require("base46").load_all_highlights(name)
  require("utils.themes").load_highlights()
end

colorscheme.on_change = function(_, item)
  if item and item.text then
    if preview_timer then
      preview_timer:stop()
      preview_timer:close()
    end
    preview_timer = vim.loop.new_timer()
    preview_timer:start(
      80,
      0,
      vim.schedule_wrap(function()
        reload_theme(item.text)
      end)
    )
  end
end

colorscheme.confirm = function(picker, item)
  confirmed = true
  picker:close()

  vim.schedule(function()
    vim.g.nvim_colorscheme = item.text
    reload_theme(item.text)
  end)
end
colorscheme.on_show = function(picker)
  local current = vim.g.nvim_colorscheme

  vim.schedule(function()
    local items = picker:items()
    for i, item in ipairs(items) do
      if item.text == current then
        picker.list:move(i - 1)
        break
      end
    end
  end)
end
colorscheme.on_close = function()
  if not confirmed and original_theme then
    vim.schedule(function()
      reload_theme(original_theme)
    end)
  end
  confirmed = false
end

colorscheme.title = "󱥚 Set Colorscheme"

-- ⭐ preview 禁用用字符串 false，不是函数
colorscheme.preview = function()
  return ""
end

local M = {}
function M.colorscheme()
  Snacks.picker(vim.tbl_extend("force", colorscheme, {
    layout = {
      preset = "vscode",
    },
    -- layouts = {
    --   ivy = {
    --     layout = {
    --       box = "vertical",
    --       backdrop = false,
    --       row = -1,
    --       width = 0,
    --       height = 0.4,
    --       border = "top",
    --       title = " {title} {live} {flags}",
    --       title_pos = "left",
    --       { win = "input", height = 1,      border = "bottom" },
    --       { win = "list",  border = "none", rich = true },
    --     },
    --   },
    -- },
  }))
end

return M
