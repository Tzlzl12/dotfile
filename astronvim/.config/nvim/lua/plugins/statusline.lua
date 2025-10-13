-- local extend_tbl = require("astrocore").extend_tbl
-- local hl = require "astroui.status.hl"
-- local status_utils = require "astroui.status.utils"
-- local M = require "astroui.status.component"
-- local function my_mode(opts)
--   opts = extend_tbl({
--     str = { str = "TS", icon = { kind = "ActiveTS", padding = { right = 1 } } },
--     surround = { separator = "left", color = hl.mode_bg },
--     hl = hl.get_attributes "mode",
--     update = {
--       "ModeChanged",
--       pattern = "*:*",
--       callback = function() vim.schedule(vim.cmd.redrawstatus) end,
--     },
--   }, opts)
--
--   return M.builder(status_utils.setup_providers(opts, { "str" }))
-- end
return {
  -- {
  --   "AstroNvim/astroui",
  --   ---@type AstroUIOpts
  --   opts = {
  --     -- add new user interface icon
  --     icons = {
  --       VimIcon = "",
  --       ScrollText = "",
  --       GitBranch = "",
  --       GitAdd = "",
  --       GitChange = "",
  --       GitDelete = "",
  --     },
  --     -- modify variables used by heirline but not defined in the setup call directly
  --     status = {
  --       -- define the separators between each section
  --       separators = {
  --         left = { "", "" }, -- separator for the left side of the statusline
  --         right = { " ", "" }, -- separator for the right side of the statusline
  --         tab = { "", "" },
  --       },
  --       -- add new colors that can be used by heirline
  --       colors = function(hl)
  --         local get_hlgroup = require("astroui").get_hlgroup
  --         -- use helper function to get highlight group properties
  --         local comment_fg = get_hlgroup("Comment").fg
  --         hl.git_branch_fg = comment_fg
  --         hl.git_added = comment_fg
  --         hl.git_changed = comment_fg
  --         hl.git_removed = comment_fg
  --         hl.blank_bg = get_hlgroup("Folded").fg
  --         hl.file_info_bg = get_hlgroup("Visual").bg
  --         hl.nav_icon_bg = get_hlgroup("String").fg
  --         hl.nav_fg = hl.nav_icon_bg
  --         hl.folder_icon_bg = get_hlgroup("Error").fg
  --         return hl
  --       end,
  --       attributes = {
  --         mode = { bold = true },
  --       },
  --       icon_highlights = {
  --         file_icon = {
  --           statusline = false,
  --         },
  --       },
  --     },
  --   },
  -- },
  -- {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"
    opts.statusline = {
      -- default highlight for the entire statusline
      hl = { fg = "fg", bg = "bg" },
      status.component.mode(),
      -- my_mode(),
      status.component.git_branch(),
      status.component.file_info(),
      status.component.git_diff(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.lsp(),
      status.component.diagnostics(),
      status.component.virtual_env(),
      status.component.treesitter { str = { str = "TS", icon = { kind = "ActiveTS" } } },
      -- status.component.tabline_file_info(),
      status.component.nav(),
      status.component.mode { surround = { separator = "right" } },
    }
  end,
}
