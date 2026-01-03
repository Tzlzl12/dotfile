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
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
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
