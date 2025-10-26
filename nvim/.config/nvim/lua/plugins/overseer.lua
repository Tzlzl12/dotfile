return {
  "stevearc/overseer.nvim",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction ",
    "OverseerClearCache",
  },
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@param opts overseer.Config
  opts = function(_, opts)
    if require("utils").is_available "toggleterm.nvim" then
      opts.strategy = "toggleterm"
    end
    -- opts.strategy = { "terminal" }
    ---@diagnostic disable-next-line: inject-field
    opts.templates = {
      "make",
      "user.c",
      "user.python",
      "user.uv",
      -- "user.dotnet",
      "user.cargo",
      "user.pio",
      -- "user.deno", "user.js"
    }
    opts.dap = false
    ---@diagnostic disable-next-line: inject-field
    opts.task_list = {
      max_width = { 50, 0.2 },
      -- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
      min_width = { 30, 0.1 },
      direction = "right",
      bindings = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["q"] = "<Cmd>close<CR>",
        ["f"] = "IncreaseDetail",
        ["u"] = "DecreaseDetail",
        ["<C-f>"] = "ScrollOutputUp",
        ["<C-b>"] = "ScrollOutputDown",
      },
    }

    -- ---@diagnostic disable-next-line: undefined-field
    -- opts.add_template_hook({
    --   module = "^make$",
    -- }, function(task_defn, util)
    --   util.add_component(task_defn, { "on_output_quickfix", open_on_exit = "failure" })
    --   util.add_component(task_defn, "on_complete_notify")
    --   util.add_component(task_defn, { "display_duration", detail_level = 1 })
    -- end)
  end,
  keys = {

    { "<leader>rt", "<Cmd>OverseerToggle right<CR>", desc = "Overseer Toggle" },
    { "<leader>rm", "<Cmd>OverseerRunCmd<CR>", desc = "Overseer Run Command" },
    -- maps.n[prefix .. "c"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Run Command" }
    { "<leader>rr", "<Cmd>OverseerRun<CR>", desc = "Overseer Run Task" },
    -- maps.n[prefix .. "q"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
    -- { "<leader>rc", "<Cmd>OverseerTaskAction<CR>", desc = "Overseer Task Action" },
    { "<leader>ri", "<Cmd>OverseerInfo<CR>", desc = "Overseer Info" },
  },
}
