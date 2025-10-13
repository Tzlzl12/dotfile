local ensure_installed = { "lua", "markdown", "markdown_inline", "latex", "ron", "toml", "yaml", "json", "vim" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      --
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      pcall(require, "nvim-treesitter.query_predicates")
    end,
    opts_extend = { "ensure_installed" },
    opts = {
      auto_install = vim.fn.executable "git" == 1 and vim.fn.executable "tree-sitter" == 1, -- only enable auto install if `tree-sitter` cli is installed
      ensure_installed = ensure_installed,
      highlight = { enable = true },
      incremental_selection = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
    -- end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      dofile(vim.g.base46_cache .. "treesitter")
    end,
  },
}
