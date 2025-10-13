if not vim.g.nvchad_lsp.pyright then
  return {}
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Ensure C/C++ debugger is installed
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "debugpy" } },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst", "python" } },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
      -- local neotest_python_avail, neotest_python = pcall(require, "neotest-python")
      -- if neotest_python_avail then
      --   table.insert(opts.adapters, neotest_python)
      -- end
      table.insert(
        opts.adapters,
        require "neotest-python" {
          runner = "pytest",
          pytest_discover_instances = true,
        }
      )
    end,
  },
}
