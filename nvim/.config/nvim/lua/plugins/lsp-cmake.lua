-- if not vim.g.nvchad_lsp.cmake then
-- 	return {}
-- end

local get_root_dir = require("utils").workspace

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cmake" } },
  },
  {
    "Civitasv/cmake-tools.nvim",
    enabled = false,
    lazy = true,
    init = function()
      local function check()
        local cwd = get_root_dir()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load { plugins = { "cmake-tools.nvim" } }
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          check()
        end,
      })
    end,
    keys = function()
      return {
        { "cmg", ":CMakeGenerate<cr>", { desc = "Generate CMake Generate" } },
        { "cmb", ":CMakeBuild<cr>", { desc = "GEnerate CMake Build" } },
      }
    end,
    opts = {
      cmake_command = "cmake", -- this is used to specify cmake command path
      ctest_command = "ctest", -- this is used to specify ctest command path
      cmake_use_preset = true,
      cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
      cmake_soft_link_compile_commands = false, -- this will automatically make a soft link from compile commands file to project root dir
      cmake_compile_commands_from_lsp = true, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
      cmake_build_directory = "build",
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
        "-DCMAKE_COLOR_DIAGNOSTICS=1",
        "-GNinja",
      }, -- this will be passed when invoke `CMakeGenerate`
      cmake_build_options = {
        "-j",
      }, -- this will be passed when invoke `CMakeBuild`
      -- support macro expansion:
      --       ${kit}
      --       ${kitGenerator}
      --       ${variant:xx}
    },
  },
}
