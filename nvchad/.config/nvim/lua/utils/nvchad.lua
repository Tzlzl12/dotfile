local M = {}
local codecom = require "utils.code_process"

local utils = require "utils"

codecom:init()

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end
local get_ai_cmp_status = function()
  return vim.g.nvchad_inline_codeium and "%#NVCHAD_StatusLine_Codeium#" .. " 󰘦 "
    or "%#NVCHAD_StatusLine_Copilot#" .. "  "
end

local get_code_process_status = function()
  if vim.g.nvchad_codecompanion_process then
    return codecom:update_status()
  else
    return ""
  end
end

M.ai = function()
  local ai_cmp_status = get_ai_cmp_status()
  local code_process_status = get_code_process_status()

  if ai_cmp_status == "" and code_process_status == "" then
    return ""
  end

  return ai_cmp_status .. "%#NVCHAD_StatusLine2#" .. code_process_status .. "%*"
end

M.nvchad_git = function()
  if not vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status then
    return ""
  end

  local git_status = vim.b[stbufnr()].gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0)
      and ("%#MiniDiffSignAdd#" .. "  " .. git_status.added .. "%*")
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and ("%#MiniDiffSignChange#" .. "  " .. git_status.changed .. "%*")
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and ("%#MiniDiffSignDelete#" .. "  " .. git_status.removed .. "%*")
    or ""
  -- local branch_name = " " .. git_status.head
  local branch_name = git_status and git_status.head and ("%#NVCHAD_StatusLine2#" .. " " .. git_status.head .. "%*")
    or ""

  return " " .. branch_name .. added .. changed .. removed
end
return M
