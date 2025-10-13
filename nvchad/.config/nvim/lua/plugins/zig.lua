if not vim.g.nvchad_lsp.zig then
  return {}
end

return {
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = { ensure_installed = { "zig" } },
  -- },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "lawrence-laz/neotest-zig", tag = "1.3.1" },
    },
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end

      table.insert(
        opts.adapters,
        require "neotest-zig" {
          dap = {
            adapter = "lldb",
          },
        }
      )
    end,
  },
}
