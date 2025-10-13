if vim.g.nvchad_use_telescope == false then
  return {}
end

return {
  {
    "otavioschwanck/telescope-cmdline-word.nvim",
    keys = {
      {
        "<tab>",
        function()
          require("telescope-cmdline-word.picker").find_word()
        end,
        mode = "c",
      },
    },
    opts = {
      add_mappings = true, -- add <tab> mapping automatically
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        enabled = vim.fn.executable "make" == 1 or vim.fn.executable "cmake" == 1,
        build = vim.fn.executable "make" == 1 and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        config = function(...)
          require("telescope").load_extension "fzf"
        end,
      },
    },
    opts = function()
      dofile(vim.g.base46_cache .. "telescope")
      local actions = require "telescope.actions"

      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

      local function find_command()
        if 1 == vim.fn.executable "rg" then
          return { "rg", "--files", "--color", "never", "-g", "!.git" }
        elseif 1 == vim.fn.executable "fd" then
          return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable "fdfind" then
          return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
        elseif 1 == vim.fn.executable "find" and vim.fn.has "win32" == 0 then
          return { "find", ".", "-type", "f" }
        elseif 1 == vim.fn.executable "where" then
          return { "where", "/r", ".", "*" }
        end
      end

      return {
        defaults = {
          file_ignore_patterns = {
            "^%.git[/\\]", -- 忽略 .git/
            "[/\\]%.git[/\\]", -- 忽略任意层级的 .git/
            "^build[/\\]", -- 忽略根目录的 build/
            "^bin[/\\]", -- 忽略根目录的 bin/
            "^obj[/\\]", -- 忽略根目录的 obj/
          },
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              -- ["<a-i>"] = find_files_no_ignore,
              -- ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump {
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        }
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },
}
