local cmd = { "pyright-langserver", "--stdio" }
local filetypes = { "python" }
local root_markers =
  { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" }
local settings = {
  python = {
    analysis = {
      autoSearchPaths = true,
      autoImportCompletions = false,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true,
      typeCheckingMode = "standard",
      diagnosticSeverityOverrides = {
        reportAttributeAccessIssue = "none",
      },
    },
  },
}

return {
  cmd = cmd,
  filetypes = filetypes,
  root_markers = root_markers,
  settings = settings,
}
