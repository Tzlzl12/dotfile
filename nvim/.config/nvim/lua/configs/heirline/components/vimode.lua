local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local icons = require("configs.icons").icons
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local M = {}

M.ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "Normal",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "Visual",
      vs = "Vs",
      V = "^V",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "Insert",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
    mode_colors = {
      n = { fg = "#31272f", bg = "cyan" },
      i = { fg = "#31272f", bg = "green" },
      v = { fg = "#31272f", bg = "#25abe4" },
      V = { fg = "#31272f", bg = "#25abe4" },
      ["\22"] = { fg = "#31272f", bg = "#25abe4" }, -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = { fg = "#31272f", bg = "orange" },
      s = { fg = "#31272f", bg = "#25abe4" },
      S = { fg = "#31272f", bg = "#25abe4" },
      ["\19"] = { fg = "#31272f", bg = "#25abe4" }, -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = { fg = "#31272f", bg = "orange" },
      r = { fg = "#31272f", bg = "orange" },
      ["!"] = { fg = "#31272f", bg = "red" },
      t = { fg = "#31272f", bg = "green" },
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or "n"
      return self.mode_colors[mode]
    end,
  },
  {
    provider = function()
      return ""
    end,
    hl = function(self)
      local colors = self:mode_color()
      return { fg = colors.bg, bg = "None", bold = true }
    end,
  },
  {
    provider = function(self)
      return icons.vim .. "%2(" .. self.mode_names[self.mode] .. "%)"
    end,
    hl = function(self)
      local colors = self:mode_color()
      return { fg = colors.fg, bg = colors.bg, bold = true }
    end,
  },
  {
    provider = function()
      return ""
    end,
    hl = function(self)
      local colors = self:mode_color()
      return { fg = colors.bg, bg = "None", bold = true }
    end,
  },
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd "redrawstatus"
    end),
  },
}
local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format(" %d/%d", search.current, math.min(search.total, search.maxcount))
  end,
  hl = { fg = "purple", bold = true },
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = icons.rec,
  hl = { fg = "orange", bold = true },
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = { fg = "green", bold = true },
  }),
  update = {
    "RecordingEnter",
    "RecordingLeave",
  },
  { provider = " " },
}

-- WIP
local VisualRange = {
  condition = function()
    return vim.tbl_containsvim({ "V", "v" }, vim.fn.mode())
  end,
  provider = function()
    local start = vim.fn.getpos "'<"
    local stop = vim.fn.getpos "'>"
  end,
}

local ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ":%3.5(%S%)",
  hl = function(self)
    return { bold = true, fg = self:mode_color() }
  end,
}
-- M.ViMode = utils.surround({ separators.rounded_left, separators.rounded_right }, vimode_color.bg, M.ViMode)
return M
