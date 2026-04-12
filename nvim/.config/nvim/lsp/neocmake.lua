local root_markers = { ".git", "build", "cmake", "CMakeLists.txt" }
return {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },

  init_options = {
    allow_snippet = false,
    enable_documentation = true,
    scan_package = true,
  },

  root_markers = root_markers,
}
