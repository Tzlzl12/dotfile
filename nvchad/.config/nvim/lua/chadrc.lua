-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local nvchad = require "utils.nvchad"
M.base46 = {
  theme = "onedark",
  integrations = {},
  transparency = true,
  theme_toggle = { "onedark", "ayu_dark" },
}

M.ui = {
  cmp = {
    icons_left = false, -- only for non-atom styles!
    lspkind_text = true,
    style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = false, -- will work for css lsp too
      icon = "󱓻",
    },
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  statusline = {
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    order = {
      "mode",
      "file",
      "ai",
      "nvchad_git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "cwd",
      "cursor",
    },
    modules = {
      ai = nvchad.ai,
      -- codecompanion = nvchad.codecompanion,
      nvchad_git = nvchad.nvchad_git,
    },
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    order = { "buffers", "tabs", "btns" },
    modules = nil,
  },
}

M.lsp = {
  signature = true,
}
M.term = {
  winopts = { number = false },
  sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
  float = {
    relative = "editor",
    row = 0.1,
    col = 0.1,
    width = 0.8,
    height = 0.7,
    border = "single",
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "                            ",
    "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    "   ▄▀███▄     ▄██ █████▀    ",
    "   ██▄▀███▄   ███           ",
    "   ███  ▀███▄ ███           ",
    "   ███    ▀██ ███           ",
    "   ███      ▀ ███           ",
    "   ▀██ █████▄▀█▀▄██████▄    ",
    "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    "                            ",
    "     Powered By eovim     ",
    "                            ",
  },

  buttons = {
    -- { txt = "  Find File", keys = "f", cmd = "Telescope find_files" },
    {
      txt = "  Projects",
      keys = "p",
      hl = "DashboardCyan",
      cmd = "lua Snacks.picker.projects(require('extensions.projects'))<cr>",
    },
    {
      txt = "󱥚  Themes",
      keys = "t",
      hl = "DashboardRed",
      cmd = "lua Snacks.picker.colorschemes(require('extensions.themes'))",
    },
    {
      txt = "  Config",
      keys = "c",
      hl = "DashboardYellow",
      cmd = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config'), preset='ivy' })<cr>",
    },
    {
      txt = "  Session",
      keys = "s",
      hl = "DashboardGreen",
      cmd = "lua require('persistence').load({ last = true })",
    },
    -- -- more... check nvconfig.lua file for full list of buttons
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },
    --
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
  -- footer = {
  --   "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
  -- },
}
M.cheatsheet = {
  excluded_groups = {
    "LSP",
    "Whichkey",
    "Git (x)",
    "LSP (v)",
    "General (i)",
    "Comment",
    ":help (i)",
    "Comment (x)",
    "General (t)",
    "Toggle (v)",
    "Dap (v)",
    "Terminal (t)",
    ":help (x)",
    "Comment (x)",
    "Which-key-trigger (i)",
    "Opens (x)",
    ":help",
    "Opens",
    "Go",
    "Go (x)",
    "Buffer",
  }, -- can add group name or with mode
}
M.base46.hl_add = {
  -- ["@lsp.mod.inactive"] = { link = "LspInactiveRegion" },
  NVCHAD_StatusLine1 = { fg = "#89b4fa" },
  NVCHAD_StatusLine2 = { fg = "#a6e3a1" },
  NVCHAD_StatusLine3 = { fg = "#f9e2af" },
  NVCHAD_StatusLine_Codeium = { fg = "#9759F3" },
  NVCHAD_StatusLine_Copilot = { fg = "#6E40C9" },
  NVCHAD_StatusLine4 = { bg = "#32363e" },
  NVCHAD_StatusLine5 = { bg = "#74c7ec" },
  NVCHAD_StatusLine6 = { bg = "#cba6f7" },

  LspInactiveRegion = { fg = "#9E9E9E", italic = true },

  DashboardCyan = { fg = "#7dcfff" }, -- 适配 AstronVim (Tokyonight) cyan
  DashboardMagenta = { fg = "#bb9af7" }, -- 适配 AstronVim (Tokyonight) magenta
  DashboardYellow = { fg = "#e0af68" }, -- 适配 AstronVim (Tokyonight) yellow
  DashboardGreen = { fg = "#9ece6a" }, -- 适配 AstronVim (Tokyonight) green
  DashboardRed = { fg = "#f7768e" }, -- 适配 AstronVim (Tokyonight) red
  DashboardBlue = { fg = "#7aa2f7" }, -- 适配 AstronVim (Tokyonight) blue

  -- rendermarkdown
  RenderMarkdownCode = { bg = "NONE" },
  RenderMarkdownCodeInline = { bg = "NONE" },

  -- illuminate
  IlluminatedWordText = { bg = "#3A3A3A" },
  IlluminatedWordRead = { bg = "#3A3A3A" },
  IlluminatedWordWrite = { bg = "#3A3A3A" },

  -- rainbow delimiter
  RainbowDelimiterRed = { fg = "#f7768e" }, -- astrontheme/tokyonight red
  RainbowDelimiterYellow = { fg = "#e0af68" }, -- astrontheme/tokyonight yellow
  RainbowDelimiterBlue = { fg = "#7aa2f7" }, -- astrontheme/tokyonight blue
  RainbowDelimiterOrange = { fg = "#ff9e64" }, -- astrontheme/tokyonight orange
  RainbowDelimiterGreen = { fg = "#9ece6a" }, -- astrontheme/tokyonight green
  RainbowDelimiterViolet = { fg = "#bb9af7" }, -- astrontheme/tokyonight purple
  RainbowDelimiterCyan = { fg = "#7dc4e4" }, -- astrontheme/tokyonight aqua

  LineNr = { fg = "#80deea" },
  LineNrBelow = { fg = "#64B5F6" },
  LineNrAbove = { fg = "#A5D6A7" },
  -- -- Normal = { bg = "#000000" },

  -- float border
  FzfLuaBorder = { bg = "NONE" },
  FzfLuaTitle = { bg = "NONE" },
  FzfLuaBackdrop = { bg = "NONE" },
  FzfLuaHeaderText = { bg = "NONE" },
  FzfLuaTabTitle = { bg = "NONE" },
  FzfLuaFzfBorder = { fg = "#569cd6", bg = "NONE" },

  TelescopeBorder = { fg = "#569cd6", bg = "NONE" },
  TelescopeNormal = { bg = "NONE" },
  TelescopePreviewNormal = { bg = "NONE" },
  TelescopeResultsNormal = { bg = "NONE" },
  TelescopePromptNormal = { bg = "NONE" },
  TelescopePromptBorder = { bg = "NONE" },
  TelescopePromptTitle = { fg = "#0f94d2", bg = "NONE" },
  TelescopeSelectionCaret = { bg = "NONE" },
  TelescopeMatching = { fg = "#0f94d2", bg = "NONE" },
  TelescopePromptPrefix = { fg = "#ff8a65" },
  TelescopePreviewTitle = { fg = "#0f94d2", bg = "NONE" },
  TelescopePreviewBorder = { fg = "#0f94d2", bg = "NONE" },
  TelescopeResultsTitle = { fg = "#0f94d2", bg = "NONE" },
  TelescopeResultsBorder = { fg = "#0f94d2", bg = "NONE" },
  TabLineSel = { bg = "#1e2220" },
  background_colour = { bg = "NONE" },
  --

  --  CMP
  Pmenu = { fg = "#64B5F6", bg = "NONE" },
  PmenuSel = { fg = "#61afef", bg = "NONE" },
  PmenuTumb = { bg = "NONE" },
  CmpItemMenu = { fg = "#C792EA", bg = "NONE", bold = true },
  CmpItemAbbrMatch = { bg = "NONE", fg = "#569CD6", bold = true },
  CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },

  BlinkCmpMenuSelection = { bg = "#a6e3a1", fg = "#fb4934" }, -- gruvbox green/red
  BlinkCmpKindEnum = { fg = "#fb4934" }, -- gruvbox red
  BlinkCmpKindFile = { fg = "#d65d0e" }, -- gruvbox orange
  BlinkCmpKindText = { fg = "#b8bb26" }, -- gruvbox green
  BlinkCmpKindUnit = { fg = "#83a598" }, -- gruvbox blue
  BlinkCmpGhostText = { fg = "#928374" }, -- gruvbox gray
  BlinkCmpKindClass = { fg = "#83a598" }, -- gruvbox blue
  BlinkCmpKindColor = { fg = "#fb4934" }, -- gruvbox red
  BlinkCmpKindEvent = { fg = "#fb4934" }, -- gruvbox red
  BlinkCmpKindField = { fg = "#fabd2f" }, -- gruvbox yellow
  BlinkCmpKindValue = { fg = "#d3869b" }, -- gruvbox purple
  BlinkCmpKindFolder = { fg = "#d65d0e" }, -- gruvbox orange
  BlinkCmpKindMethod = { fg = "#8ec07c" }, -- gruvbox aqua
  BlinkCmpKindModule = { fg = "#83a598" }, -- gruvbox blue
  BlinkCmpKindStruct = { fg = "#83a598" }, -- gruvbox blue
  BlinkCmpMenuBorder = { fg = "#665c54" }, -- gruvbox dark gray
  BlinkCmpKindKeyword = { fg = "#fabd2f" }, -- gruvbox yellow
  BlinkCmpKindSnippet = { fg = "#b8bb26" }, -- gruvbox green
  BlinkCmpKindConstant = { fg = "#d3869b" }, -- gruvbox purple
  BlinkCmpKindFunction = { fg = "#8ec07c" }, -- gruvbox aqua
  BlinkCmpKindOperator = { fg = "#8ec07c" }, -- gruvbox aqua
  BlinkCmpKindProperty = { fg = "#fabd2f" }, -- gruvbox yellow
  BlinkCmpKindVariable = { fg = "#d3869b" }, -- gruvbox purple

  -- Gitsigns
  GitSignsAdd = { bg = "NONE", fg = "#40a02b" },
  GitSignsChange = { bg = "NONE", fg = "#df8e1d" },
  GitSignsDelete = { bg = "NONE", fg = "#d20f39" },
  GitSignsAddLn = { bg = "#dee8e0", fg = "NONE" },
  GitSignsChangeLn = { bg = "#ebd9bf", fg = "NONE" },
  GitSignsDeleteLn = { bg = "#ecdae2", fg = "NONE" },
  -- 单词级高亮 gitsigns
  GitSignsAddInline = { bg = "#c3ddc3", fg = "NONE" },
  GitSignsChangeInline = { bg = "#ebd9bf", fg = "NONE" },
  GitSignsDeleteInline = { bg = "#e8b9c6", fg = "NONE" },
  GitSignsAddPreview = { bg = "#40a02b", fg = "#282828" },
  GitSignsDeletePreview = { bg = "#d20f39", fg = "#282828" },

  -- Dap
  -- DAP UI 图标高亮
  DapUIPlayPause = { fg = "#98be65" }, -- 绿色：运行
  DapUIRestart = { fg = "#51afef" }, -- 蓝色：重新运行
  DapUIStepInto = { fg = "#ecbe7b" }, -- 黄色：步入
  DapUIStepOver = { fg = "#c678dd" }, -- 紫色：步过
  DapUIStepOut = { fg = "#da8548" }, -- 橘棕色（适度强调）
  DapUIStepBack = { fg = "#ff6c6b" }, -- 红色（警示）
  DapUIStop = { fg = "#ff6c6b" }, -- 红色（终止）
  DapUIModifiedValue = { fg = "#ecbe7b", bold = true }, -- 黄色（突出）
  DapUIBreakpointsPath = { fg = "#5B6268" }, -- 灰蓝色（中性，适合路径）

  -- Mini-Diff
  MiniDiffSignAdd = { link = "GitSignsAdd" },
  MiniDiffSignChange = { link = "GitSignsChange" },
  MiniDiffSignDelete = { link = "GitSignsDelete" },
  MiniDiffOverAdd = { bg = "#40a02b", fg = "#282828" },
  MiniDiffOverChange = { bg = "#df8e1d", fg = "#282828" },
  MiniDiffOverChangeBuf = { bg = "#df8e1d", fg = "#282828" },
  MiniDiffOverContext = { bg = "#df8e1d", fg = "#282828" },
  MiniDiffOverContextBuf = { bg = "#df8e1d", fg = "#282828" },
  MiniDiffOverDelete = { bg = "#d20f39", fg = "#282828" },

  NormalFloat = { bg = "NONE" },
  WinBarNC = { bg = "NONE" },
  StatusLine = { bg = "NONE" },

  FloatBorder = { bg = "NONE" },
  FloatTitle = { bg = "NONE" },
  FloatFooter = { bg = "NONE" },
  TabLine = { bg = "NONE" },
  TabLineFill = { bg = "NONE" },
  Title = { bg = "NONE" },

  NotifyBackground = { bg = "#64B5F6" },
}

M.base46.hl_override = {
  -- Comment = { fg = "#6A9955", italic = true },
  ["@comment"] = { fg = "#778899", italic = true },
  ["@function.method"] = { italic = true },
  ["@keyword"] = { italic = true },
  CursorLine = { bg = "#1e2220", fg = "#ff8a65" },
  ColorColumn = { bg = "NONE" },
  LspInlayHint = { bg = "NONE" },
  Pmenu = { fg = "#64B5F6", bg = "NONE" },
  PmenuSel = { fg = "NONE", bg = "NONE" },
  PmenuTumb = { bg = "NONE" },
}

return M
