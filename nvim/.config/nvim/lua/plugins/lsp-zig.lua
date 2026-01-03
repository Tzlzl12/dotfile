return {
  {
    "nvim-neotest/neotest",

    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
      table.insert(opts.adapters, require "custom_adepters.zig")
    end,
  },
}
