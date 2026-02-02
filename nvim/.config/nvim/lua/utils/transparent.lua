local M = {}

M.highlights = {
  BlinkCmpKindEnum = { fg = "#fb4934" },
  BlinkCmpKindFile = { fg = "#d65d0e" },
  BlinkCmpKindText = { fg = "#b8bb26" },
  BlinkCmpKindUnit = { fg = "#83a598" },
  BlinkCmpGhostText = { fg = "#928374" },
  BlinkCmpKindClass = { fg = "#83a598" },
  BlinkCmpKindColor = { fg = "#fb4934" },
  BlinkCmpKindEvent = { fg = "#fb4934" },
  BlinkCmpKindField = { fg = "#fabd2f" },
  BlinkCmpKindValue = { fg = "#d3869b" },
  BlinkCmpKindFolder = { fg = "#d65d0e" },
  BlinkCmpKindMethod = { fg = "#8ec07c" },
  BlinkCmpKindModule = { fg = "#83a598" },
  BlinkCmpKindStruct = { fg = "#83a598" },
  BlinkCmpMenuBorder = { fg = "#665c54" },
  BlinkCmpKindKeyword = { fg = "#fabd2f" },
  BlinkCmpKindSnippet = { fg = "#b8bb26" },
  BlinkCmpKindConstant = { fg = "#d3869b" },
  BlinkCmpKindFunction = { fg = "#8ec07c" },
  BlinkCmpKindOperator = { fg = "#8ec07c" },
  BlinkCmpKindProperty = { fg = "#fabd2f" },
  BlinkCmpKindVariable = { fg = "#d3869b" },
  -- pop menu for transparent
}

M.transparent = function(self)
  for group, colors in pairs(self.highlights) do
    vim.api.nvim_set_hl(0, group, colors)
  end
end
return M
