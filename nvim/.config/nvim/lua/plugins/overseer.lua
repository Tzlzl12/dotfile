return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerInfo",
    "OverseerShell",
    "OverseerOpen",
    "OverseerRun",
    "OverseerToggle",
    "OverseerTestOutput",
  },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    dap = false,
    disable_template_modules = { "overseer.template.cargo" },
    -- templates = {
    --   -- "make",
    --   -- "vscode",
    --   "user.c",
    --   "user.uv",
    --   "user.cargo",
    --   "user.pio",
    --   "user.zig",
    --   -- "user.deno", "user.js"
    -- },
    log_level = vim.log.levels.TRACE,
    component_aliases = {
      default = {
        "on_exit_set_status",
        { "on_complete_notify", system = "unfocused" },
        { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
      },
      default_neotest = {
        "unique",
        { "on_complete_notify", system = "unfocused", on_change = true },
        "default",
      },
    },
    experimental_wrap_builtins = {
      enabled = false,
      partial_condition = {
        noop = function(cmd, caller, opts)
          return true
        end,
      },
    },
    post_setup = {},
  },
  config = function(_, opts)
    require("overseer").setup(opts)
    for _, cb in pairs(opts.post_setup) do
      cb()
    end
  end,
  keys = {
    { "<leader>rt", "<Cmd>OverseerToggle right<CR>", desc = "Overseer Toggle" },
    { "<leader>rr", "<Cmd>OverseerRun<CR>", desc = "Overseer Run Task" },
    { "<leader>rc", "<Cmd>OverseerTaskAction<CR>", desc = "Overseer Task Action" },
    { "<leader>ri", "<Cmd>OverseerInfo<CR>", desc = "Overseer Info" },
  },
}
