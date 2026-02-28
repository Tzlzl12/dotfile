return {
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    lazy = true,
    opts = {},
    config = function(_, opts)
      require("pretty_hover").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      "mason.nvim",
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        lazy = true,
        opts = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
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
      --   local default = require "lsp.default"
      --   vim.lsp.config("*", {
      --     capabilities = default.capabilities,
      --     on_init = default.on_init,
      --     on_attach = default.on_attach,
      --   })
      --   require "lsp"
    end,
  },
}
