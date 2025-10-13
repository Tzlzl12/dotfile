local M = {}
if not vim.g.nvchad_lsp.zig then
  M.defaults = function() end
  return M
end

local nvlsp = require "lsp.default_config"
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function(ev)
    vim.lsp.buf.code_action {
      context = {
        only = {
          "source.organizeImports",
          -- "source.fixAll"
        },
      },
      apply = true,
    }
  end,
})

M.defaults = function()
  -- dofile(vim.g.base46_cache .. "lsp")
  -- require("nvchad.lsp").diagnostic_config()

  require("lspconfig").zls.setup {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    on_init = nvlsp.on_init,
    root_dir = require("lspconfig").util.root_pattern("build.zig.zon", "build", ".git", ".nvim"),
    cmd = { "zls" },
    settings = {
      zls = {
        semantic_tokens = "partial",
      },
    },
  }
end

return M
