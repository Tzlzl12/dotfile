return {
  name = "c build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"
    local file_without_ext = vim.fn.fnamemodify(vim.fn.expand "%:p", ":t:r")
    local file_type = vim.bo.filetype
    -- local file_dir = vim.fn.expand "%:p:h"
    -- local bin_dir = file_dir .. "/bin/" .. file_without_ext
    if file_type == "cpp" then
      return {
        cmd = { "clang++" },
        args = {
          file,
          "-o",
          "./bin/" .. file_without_ext,
          "&&",
          "./bin/" .. file_without_ext,
        },
        components = {
          -- { "on_output_quickfix", open_on_exit = "failure" },
          -- "default",
          "display_duration",
          "on_exit_set_status",
          "on_complete_notify",
          "on_output_summarize",
          { "on_result_diagnostics_trouble", close = true },
        },
      }
    elseif file_type == "c" then
      return {
        cmd = { "clang" },
        args = {
          file,
          "-o",
          "./bin/" .. file_without_ext,
          "&&",
          "./bin/" .. file_without_ext,
        },
        components = {
          -- { "on_output_quickfix", open_on_exit = "failure" },
          -- "default",
          "display_duration",
          "on_exit_set_status",
          "on_complete_notify",
          "on_output_summarize",
          { "on_result_diagnostics_trouble", close = true },
        },
      }
    end
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
}
