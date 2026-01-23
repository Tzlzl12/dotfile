return {
  name = "c build",
  builder = function()
    local file = vim.fn.expand "%:p"
    local file_without_ext = vim.fn.fnamemodify(file, ":t:r")
    local file_type = vim.bo.filetype
    local parent_dir = vim.fn.fnamemodify(file, ":h:h")
    local root_dir = require("utils").workspace()
    local bin_dir = root_dir .. "/bin"

    if vim.fn.isdirectory(bin_dir) == 0 then
      vim.fn.mkdir(bin_dir, "p")
    end

    local function build_config(compiler)
      return {
        cmd = { compiler },
        args = {
          file,
          "-g",
          "-o",
          bin_dir .. "/" .. file_without_ext,
          "&&",
          bin_dir .. "/" .. file_without_ext,
        },
        components = {
          "display_duration",
          "on_exit_set_status",
          "on_complete_notify",
          "on_output_summarize",
          { "on_result_diagnostics_trouble", close = true },
        },
      }
    end

    local compiler = nil
    if file_type == "cpp" then
      if vim.fn.executable "clang++" == 1 then
        compiler = "clang++"
      elseif vim.fn.executable "g++" == 1 then
        compiler = "g++"
      end
    elseif file_type == "c" then
      if vim.fn.executable "clang" == 1 then
        compiler = "clang"
      elseif vim.fn.executable "gcc" == 1 then
        compiler = "gcc"
      end
    end

    if compiler then
      return build_config(compiler)
    end
  end,
  condition = {
    filetype = { "cpp", "c" },
  },
}
