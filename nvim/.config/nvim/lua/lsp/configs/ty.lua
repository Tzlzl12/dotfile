local cmd = { "ty", "server" }
local filetypes = { "python" }
local root_markers =
  { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" }

return {
  cmd = cmd,
  filetypes = filetypes,
  root_markers = root_markers,
  settings = {
    ty = {},
  },
}
