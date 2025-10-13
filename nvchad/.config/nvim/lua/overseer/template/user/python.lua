return {
  name = "run python script",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"

    -- local python =
    -- local file_dir = vim.fn.expand "%:p:h"
    -- local bin_dir = file_dir .. "/bin/" .. file_without_ext
    return {
      cmd = { "python" },
      args = { file },
      components = {
        -- { "on_output_quickfix", open = true },
        "default",
        "display_duration",
        "on_exit_set_status",
        "on_complete_notify",
        "on_output_summarize",
      },
    }
  end,
  priority = 50,
  condition = {
    filetype = { "python" },
  },
}
