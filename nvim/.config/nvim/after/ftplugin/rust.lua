if vim.g.lsp_rust_loaded then
  return
end

vim.g.rust_recommended_style = 0
vim.g.lsp_rust_loaded = true

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

vim.lsp.config("rust_analyzer", {
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
      },

      diagnostics = {
        enable = true,
      },
    },
  },
})
