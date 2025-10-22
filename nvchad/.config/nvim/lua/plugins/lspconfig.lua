return {
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      require("pretty_hover").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    dependencies = {
      "mason.nvim",
      {
        "williamboman/mason.nvim",
        opts = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
        dependencies = { "roslyn.nvim" },
      },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- Enable lsp cursor word highlighting
        document_highlight = {
          enabled = true,
        },
      }
      return ret
    end,
    config = function()
      local default = require "lsp.default"

      local lsp_servers = {
        "lua_ls",
        "clangd",
        "neocmake",
        "pyright",
        "ruff",
        "denols",
      }

      for _, lsp_server in ipairs(lsp_servers) do
        local config = require("lsp." .. lsp_server)
        vim.lsp.config(lsp_server, config)
        vim.lsp.enable(lsp_server)
      end
      print "into lspconfig"
      vim.lsp.config("*", {
        capabilities = default.capabilities,
        on_init = default.on_init,
        on_attach = default.on_attach,
      })
    end,
  },
}
