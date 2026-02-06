local M = {}

local transperent_highlight = {
  BlinkCmpMenuSelection = { bg = "#a6e3a1", fg = "#fb4934" },
  Comment = { fg = "#8694a3" },
  NonText = { fg = "#7f8c98", bg = "NONE" },
  -- NonText = { fg = "#5c6370", bg = "NONE" },
  NormalFloat = { bg = "NONE" },
  NormalNC = { bg = "NONE" },
  WinBarNC = { bg = "NONE" },
  StatusLine = { bg = "NONE" },
  FloatBorder = { bg = "NONE" },
  FloatTitle = { bg = "NONE" },
  FloatFooter = { bg = "NONE" },
  TabLine = { bg = "NONE" },
  TabLineFill = { bg = "NONE" },
  Title = { bg = "NONE" },

  ColorColumn = { bg = "NONE" },
  RenderMarkdownCode = { bg = "NONE" },
  RenderMarkdownCodeInfo = { bg = "NONE" },
  RenderMarkdownCodeInline = { bg = "NONE" },
  NeotreeNormal = { bg = "NONE" },
  NeotreeNormalNC = { bg = "NONE" },
  SnacksPickerPickWin = { bg = "NONE" },
  NotifyBackground = { bg = "#64B5F6" },

  Pmenu = { fg = "#64B5F6", bg = "NONE" },
  PmenuSel = { fg = "#61afef", bg = "NONE" },
  -- PmenuTumb = { bg = "NONE" },

  RainbowDelimiterRed = { fg = "#f7768e" },
  RainbowDelimiterYellow = { fg = "#e0af68" },
  RainbowDelimiterBlue = { fg = "#7aa2f7" },
  RainbowDelimiterOrange = { fg = "#ff9e64" },
  RainbowDelimiterGreen = { fg = "#9ece6a" },
  RainbowDelimiterViolet = { fg = "#bb9af7" },
  RainbowDelimiterCyan = { fg = "#7dc4e4" },
}

local function set_highlight(hl)
  for group, colors in pairs(hl) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end
function M.get_colorscheme_config(name)
  for family, scheme in pairs(Ice.colorschemes) do
    if scheme.items[name] then
      vim.g.nvim_colorscheme = family
      return scheme
    end
  end
  return nil
end
-- 主题切换核心函数
M.colorscheme = function(colorscheme_name, transparent)
  local config = M.get_colorscheme_config(colorscheme_name)
  if not config then
    vim.notify(colorscheme_name .. " is not a valid color scheme!", vim.log.levels.ERROR)
    return
  end

  -- vim.g.nvim_colorhelper = config.color_helper or ""
  local actual_name = config.items[colorscheme_name]
  vim.g.nvim_colorscheme = actual_name
  vim.cmd("colorscheme " .. vim.g.nvim_colorscheme)
  vim.o.background = colorscheme_name:match "^light-" and "light" or "dark"

  if config.transparent then
    set_highlight(transperent_highlight)
  end
  -- 触发自动命令
  vim.api.nvim_exec_autocmds("User", { pattern = "IceAfter colorscheme" })
end
return M
