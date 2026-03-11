local root_markers = { ".stylua.toml", "init.lua", ".git" }

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = root_markers,
  settings = {},
}
