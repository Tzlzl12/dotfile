return {
  name = "uv run",
  builder = function()
    -- Full path to current file (see :help expand())
    local cwd = vim.uv.cwd()
    local interpreter = ""
    if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
      if vim.fn.executable "uv" == 1 then
        interpreter = "uv"
      end
    end

    return {
      cmd = { interpreter },
      args = { "run", "main.py" },
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
  priority = 500,
  condition = {
    filetype = { "python" },
  },
}
