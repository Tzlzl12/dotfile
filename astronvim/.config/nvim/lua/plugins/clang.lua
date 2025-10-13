local uname = (vim.uv or vim.loop).os_uname()
local is_linux_arm = uname.sysname == "Linux" and (uname.machine == "aarch64" or vim.startswith(uname.machine, "arm"))

return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("keep", opts.config, {
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
          cmd = {
            "clangd",
            "--log=verbose",
            "--pretty",
            "--all-scopes-completion",
            "--completion-style=bundled",
            "--cross-file-rename",
            "--header-insertion=iwyu",
            "--header-insertion=never",
            "--header-insertion-decorators",
            "--background-index",
            "--clang-tidy",
            -- "--clang-tidy-checks=cppcoreguidelines-*,performance-*,bugprone-*,portability-*,modernize-*,google-*",
            "-j=2",
            "--pch-storage=disk",
            "--function-arg-placeholders=false",
            "--compile-commands-dir=./build",
          },
          root_dir = require("lspconfig").util.root_pattern("CMakeLists.txt", "build", ".clangd", ".git", ".nvim"),
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          inlay_hints = {
            enabled = true,
          },
          -- Be aware that you also will need to properly configure your LSP server to
          -- provide the code lenses.
          codelens = {
            enabled = true,
          },
        },
      })
      if is_linux_arm then opts.servers = require("astrocore").list_insert_unique(opts.servers, { "clangd" }) end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed =
          require("astrocore").list_insert_unique(opts.ensure_installed, { "cpp", "c", "objc", "cuda", "proto" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      if not is_linux_arm then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "clangd" })
      end
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        inlay_hints = {
          inline = false,
        },
        ast = {
          --These require codicons (https://github.com/microsoft/vscode-codicons)
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
        autocmds = {
          clangd_extensions = {
            {
              event = "LspAttach",
              desc = "Load clangd_extensions with clangd",
              callback = function(args)
                if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
                  require "clangd_extensions"
                  vim.api.nvim_del_augroup_by_name "clangd_extensions"
                end
              end,
            },
          },
          clangd_extension_mappings = {
            {
              event = "LspAttach",
              desc = "Load clangd_extensions with clangd",
              callback = function(args)
                if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
                  require("astrocore").set_mappings({
                    n = {
                      ["<Leader>lw"] = { "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch source/header file" },
                    },
                  }, { buffer = args.buf })
                end
              end,
            },
          },
        },
      },
    },
  },
}
