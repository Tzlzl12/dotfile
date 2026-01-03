local conditions = require "heirline.conditions"
local utils = require "heirline.utils"
 
local icons = require("configs.heirline.common").icons
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local file_color = "orange"
local M = {}
M.FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color, bg = file_color }
  end,
}

M.FileName = {
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ":t")
    if self.lfilename == "" then
      self.lfilename = "[No Name]"
    end
    if not conditions.width_percent_below(#self.lfilename, 0.27) then
      self.lfilename = vim.fn.pathshorten(self.lfilename)
    end
  end,
  hl = function()
    if vim.bo.modified then
      return { fg = "black", bg = file_color, bold = true, italic = true }
    end
    return { fg = "black", bg = file_color }
  end,
  -- flexible = 2,
  -- {
  --   provider = function(self)
  --     return self.lfilename
  --   end,
  --   hl = { fg = "black", bg = file_color },
  -- },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.lfilename)
    end,
    hl = { fg = "black", bg = file_color },
  },
}

M.FileFlags = {
  -- 只有当至少一个子组件匹配时才显示
  fallthrough = false,

  -- 1. 优先显示修改标记
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = icons.modified,
    hl = { fg = "green", bg = file_color },
    -- ... 你的 on_click 逻辑 ...
  },

  -- 2. 其次显示只读标记
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = icons.readonly, -- 建议前面加个空格美化
    hl = { fg = "black", bg = file_color },
  },

  -- 3. 以上皆不满足时的“保底”显示（即：普通状态）
  {
    provider = " ", -- 这里不需要 condition，作为最后的 fallback
    hl = { fg = file_color, bg = file_color },
  },
}

M.FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  M.FileIcon,
  M.FileName,
  unpack(M.FileFlags),
}
M.FileNameBlock = utils.surround({ separators.slant_left, separators.slant_right }, file_color, M.FileNameBlock)

M.FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = "Type",
}

M.FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

M.FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and fmt:upper()
  end,
}

M.FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize <= 0 then
      return "0" .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
  end,
}

M.FileLastModified = {
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date("%c", ftime)
  end,
}
return M
