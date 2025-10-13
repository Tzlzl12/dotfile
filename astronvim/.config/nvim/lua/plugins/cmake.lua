return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("keep", opts.config, {
        cmake = {
          root_dir = require("lspconfig").util.root_pattern("CMakeLists.txt", "build", ".git", ".nvim"),
        },
      })
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load { plugins = { "cmake-tools.nvim" } }
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then check() end
        end,
      })
    end,
    config = function()
      require("cmake-tools").setup {
        cmake_regenerate_on_save = false,
        cmake_build_options = {
          "-GNinja",
          "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
        },
        cmake_build_directory = "build",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "cmake" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "cmake" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "cmake-language-server" })
    end,
  },
}
