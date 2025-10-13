return {
  name = "deno run",
  builder = function()
    local file = vim.fn.expand "%:p"

    return {
      cmd = { "deno" },
      args = { "run", file },
      components = {
        "display_duration",
        "on_exit_set_status",
        "on_complete_notify",
        "on_output_summarize",
        { "on_result_diagnostics_trouble", close = true },
      },
    }
  end,
  condition = {
    filetype = { "javascript", "typescript" },
  },
}
