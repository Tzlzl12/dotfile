vim.opt_local.conceallevel = 0
-- vim.lsp.enable "biome" -- for format

vim.lsp.start {
  name = "biome",
  cmd = { "biome", "lsp-proxy" },
  root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
}
