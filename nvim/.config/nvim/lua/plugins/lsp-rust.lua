-- if not vim.g.nvchad_lsp.rust then
-- 	return {}
-- end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "toml" } },
  },
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    enabled = vim.g.nvchad_lsp_rust,
    opts = {
      server = {
        on_attach = function(_, bufnr)
          require "keymap.lsp"
          require "keymap.goto"

          vim.keymap.set("n", "gh", function()
            vim.lsp.buf.hover { border = "rounded" }
          end, { buffer = bufnr })

          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
          vim.keymap.set("n", "<leader>ce", function()
            vim.cmd.RustLsp "expandMacro"
          end, { buffer = bufnr })

          vim.keymap.set("n", "<leader>cf", function()
            vim.cmd.RustLsp "joinLines"
          end, { buffer = bufnr })

          vim.keymap.set("n", "<leader>cl", function()
            vim.cmd.RustLsp "codeLens"
          end, { buffer = bufnr })
        end,

        -- default_settings = {
        --   ["rust-analyzer"] = {
        --     cargo = {
        --       allFeatures = true,
        --       buildScripts = { enable = true },
        --     },
        --
        --     checkOnSave = {
        --       command = "clippy",
        --     },
        --
        --     procMacro = {
        --       enable = true,
        --     },
        --
        --     diagnostics = {
        --       enable = true,
        --     },
        --   },
        -- },
      },
    },

    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, opts)

      if vim.fn.executable "rust-analyzer" == 0 then
        vim.notify("rust-analyzer not found in PATH", vim.log.levels.WARN)
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
      local rustaceanvim_avail, rustaceanvim = pcall(require, "rustaceanvim.neotest")
      if rustaceanvim_avail then
        table.insert(opts.adapters, rustaceanvim)
      end
    end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = { enabled = false },
      },
    },
  },
}
