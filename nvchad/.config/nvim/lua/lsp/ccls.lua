local M = {}
if not vim.g.nvchad_lsp.ccls then
  M.defaults = function() end
  return M
end
local nvlsp = require "lsp.default_config"

M.defaults = function()
  -- dofile(vim.g.base46_cache .. "lsp")
  -- require("nvchad.lsp").diagnostic_config()

  require("lspconfig").ccls.setup {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    on_init = nvlsp.on_init,

    root_dir = require("lspconfig").util.root_pattern(
      "CMakeLists.txt",
      "build",
      ".git",
      ".nvim",
      ".ccls",
      ".ccls-cache",
      "platformio.ini"
    ),

    init_options = {
      cache = {
        directory = ".ccls-cache",
      },
      codelen = {
        renderInline = true,
      },
      compilationDatabaseDirectory = "build",
      index = {
        threads = 0,
        comments = 1,
      },
      clang = {
        excludeArgs = { "-frounding-math" },
      },
    },
  }
end

return M
