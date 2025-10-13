local before_init = function(_, c)
  if not c.settings then
    c.settings = {}
  end
  if not c.settings.python then
    c.settings.python = {}
  end
  c.settings.python.pythonPath = vim.fn.exepath "python"
end
-- local

local settings = {
  basedpyright = {
    disableOrganizeImports = true,
    disableTaggedHints = false,
    analysis = {
      -- logLevel = "Warning",
      typeCheckingMode = "basic",
      autoImportCompletions = true,
      -- autoSearchPaths = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
      reportMissingTypeStubs = false,
      diagnosticSeverityOverrides = {
        reportUnusedImport = "none",
        reportUnusedFunction = "information",
        reportUnusedVariable = "information",
        -- reportGeneralTypeIssues = "information",
        reportOptionalMemberAccess = "none",
        reportOptionalSubscript = "none",
        reportPrivateImportUsage = "none",
        reportGeneralTypeIssues = "none",
      },
    },
  },
}
