local Align = { provider = "%=" }
local Space = { provider = " " }
local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local components = require "configs.heirline.components"

local DefaultStatusline = {
  {
    condition = function(self)
      if vim.o.laststatus ~= 3 then
        return false
      end
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "neo-tree" then
          self.winid = win
          return true
        end
      end
    end,
    provider = function(self)
      return string.rep(" ", vim.api.nvim_win_get_width(self.winid))
    end,
    hl = {
      bg = utils.get_highlight("NeoTreeNormal").bg,
    },
  },
  components.Vimode,
  Space,
  components.Spell,
  {
    condition = function()
      return vim.wo.spell
    end,
    provider = function()
      return " "
    end,
  },
  {
    flexible = 3,
    -- { components.Git.gitbranch, Space },
    { components.WorkDir.workDir, Space },
    { provider = "" },
  },
  components.File.FileNameBlock,
  -- { provider = "%<" },
  Space,
  {
    flexible = 2,
    -- { components.WorkDir.workDir, Space, components.Git.gitInfo },
    -- { components.WorkDir.workDir },
    -- { provider = "" },
    { components.Git.gitbranch, components.Git.gitInfo, Space },
    { components.Git.gitbranch },
  },
  Align,
  Align,
  components.Diagnostics,
  Space,
  {
    flexible = 1,
    { components.LspActive.LspIcon, components.LspActive.LspInfo },
    { components.LspActive.LspIcon },
  }, -- VirtualEnv,
  -- components.File.FileType,
  -- { flexible = 3, { components.File.FileEncoding, Space }, { provider = "" } },
  -- SearchCount,
  Space,
  components.ScrollBar.Ruler,
  Space,
  components.ScrollBar.ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  { hl = { fg = "gray", force = true }, components.WorkDir },
  components.File.FileNameBlock,
  { provider = "%<" },
  Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    }
  end,
  components.File.FileType,
  { provider = "%q" },
  Space,
  components.HelpFilename,
  Align,
}

local GitStatusline = {
  condition = function()
    return conditions.buffer_matches {
      filetype = { "^git.*", "fugitive" },
    }
  end,
  components.File.FileType,
  Space,
  {
    provider = function()
      return vim.fn.FugitiveStatusline()
    end,
  },
  Space,
  Align,
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches { buftype = { "terminal" } }
  end,
  hl = { bg = "None" },
  -- components.ViMode,
  Space,
  components.TerminalName,
  Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  static = {},
  fallthrough = false,
  -- GitStatusline,
  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

return StatusLines
