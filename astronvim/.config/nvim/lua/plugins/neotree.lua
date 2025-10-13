local git_available = vim.fn.executable "git" == 1

local sources = {
  { source = "filesystem", display_name = "File" },
  { source = "diagnostics", display_name = "Diagnostic" },
  { source = "document_symbols", display_name = "Sym" },
}
if git_available then table.insert(sources, 2, { source = "git_status", display_name = "Git" }) end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup {
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          }
        end,
      },
    },
    opts = {
      sources = { "filesystem", git_available and "git_status" or nil, "document_symbols" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = sources,
      },
      filesystem = {
        filtered_items = {
          hide_hidden = false,
          hide_gitignored = false,
        },
        always_show = { -- remains visible even if other settings would normally hide it
          ".gitignore",
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚",
            modified = "", -- or "",
            deleted = "",
            renamed = "",
            unmerged = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 25,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
    },
  },
}
