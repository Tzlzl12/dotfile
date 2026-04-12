return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true },
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
        attributes = { enable = true },
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}
