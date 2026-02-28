local M = {}

local function get_custom_highlight()
  local colors = pcall(require, "base46.utils") and require("base46.utils").get_theme_tb "base_30" or {}
  return {
    BlinkCmpMenuSelection = { bg = "#a6e3a1", fg = "#fb4934" },
    RainbowDelimiterRed = { fg = colors.red or "#f7768e" },
    RainbowDelimiterYellow = { fg = colors.yellow or "#e0af68" },
    RainbowDelimiterBlue = { fg = colors.blue or "#7aa2f7" },
    RainbowDelimiterOrange = { fg = colors.orange or "#ff9e64" },
    RainbowDelimiterGreen = { fg = colors.green or "#9ece6a" },
    RainbowDelimiterViolet = { fg = colors.purple or "#bb9af7" },
    RainbowDelimiterCyan = { fg = colors.cyan or "#7dc4e4" },
    Pmenu = { fg = colors.blue or "#64B5F6", bg = "NONE" },
    PmenuSel = { fg = colors.blue or "#61afef", bg = "NONE" },
  }
end

local transperent_highlight = {
  Comment = { fg = "#8694a3" },
  NonText = { fg = "#7f8c98", bg = "NONE" },
  SignColumn = { bg = "NONE" },
  FoldColumn = { bg = "NONE" },
  -- LineNr = { bg = "NONE" },
  -- CursorLineNr = { bg = "NONE" },
  WinSeparator = { bg = "NONE" },

  Normal = { bg = "NONE" },
  NormalFloat = { bg = "NONE" },
  NormalNC = { bg = "NONE" },
  WinBarNC = { bg = "NONE" },
  -- Search = { bg = "NONE" },
  -- IncSearch = { bg = "NONE" },

  StatusLine = { bg = "NONE" },
  StatusLineNC = { bg = "NONE" },
  MsgArea = { bg = "NONE" },

  FloatBorder = { bg = "NONE" },
  FloatTitle = { bg = "NONE" },
  FloatFooter = { bg = "NONE" },
  TabLine = { bg = "NONE" },
  TabLineFill = { bg = "NONE" },
  Title = { bg = "NONE" },

  ColorColumn = { bg = "NONE" },
  -- plugins highlight
  NeotreeNormal = { bg = "NONE" },
  NeotreeNormalNC = { bg = "NONE" },
  RenderMarkdownCode = { bg = "NONE" },
  RenderMarkdownCodeInfo = { bg = "NONE" },
  RenderMarkdownCodeInline = { bg = "NONE" },

  SnacksPickerPickWin = { bg = "NONE" },
}

local function set_highlight(hl)
  for group, colors in pairs(hl) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end

M.load_highlights = function()
  set_highlight(get_custom_highlight())
  if vim.g.transparent_enable then
    set_highlight(transperent_highlight)
  end
end

function M.get_colorscheme_config(name)
  for family, scheme in pairs(Ice.colorschemes) do
    if scheme.items[name] then
      return scheme
    end
  end
  return nil
end

-- 主题切换核心函数
M.colorscheme = function(colorscheme_name, transparent)
  local config = M.get_colorscheme_config(colorscheme_name)
  local actual_name
  if config then
    actual_name = config.items[colorscheme_name]
    -- vim.notify(colorscheme_name .. " is not a valid color scheme!", vim.log.levels.ERROR)
    -- return
  else
    actual_name = colorscheme_name
  end

  -- vim.g.nvim_colorhelper = config.color_helper or ""
  -- vim.g.nvim_colorscheme = actual_name
  vim.cmd("colorscheme " .. actual_name)
  -- vim.o.background = colorscheme_name:match "^light-" and "light" or "dark"

  -- 触发自动命令
  vim.api.nvim_exec_autocmds("User", { pattern = "IceAfter colorscheme" })
end
return M
