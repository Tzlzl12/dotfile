local find_git_root = require("utils").find_git_root

---@diagnostic disable: undefined-global
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dim = { enabled = true },
      input = { enabled = true },
      terminal = { enabled = true },
      notifier = {
        enabled = true,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
      },
      zen = { enabled = true },
    },
  },
  {
    "folke/snacks.nvim",
    -- init = function()
    --   local fs = vim.api.nvim_create_augroup("FileSystem", { clear = true })
    --   vim.api.nvim_create_autocmd("BufEnter", {
    --     once = true,
    --     group = fs,
    --     callback = function()
    --       local state = vim.uv.fs_stat(vim.fn.argv(0))
    --       if state and state.type == "directory" then
    --         local buf = vim.api.nvim_get_current_buf()
    --         vim.api.nvim_buf_delete(buf, { force = true })
    --         Snacks.picker.explorer {}
    --       end
    --     end,
    --   })
    -- end,
    opts = function(_, opts)
      opts.picker = {
        sources = {
          explorer = {
            -- replace_netrw = true,
            layout = {
              auto_hide = { "input" },
              preset = "left",
              layout = {
                width = 0.3,
                min_width = 30,
              },
            },
            win = {
              list = {
                keys = {
                  ["."] = function(picker)
                    picker:action "tcd"
                    -- 然后关闭
                    picker:close()
                  end,
                  ["<C-n>"] = "close",
                },
              },
            },
          },
        },
        prompt = " ",
        layout = {
          preset = "ivy",
        },
        layouts = {
          -- I wanted to modify the ivy layout height and pckreview pane width,
          -- this is the only way I was able to do it
          -- NOTE: I don't think this is the right way as I'm declaring all the
          -- other values below, if you know a better way, let me know
          --
          -- Then call this layout in the keymaps above
          -- got example from here
          -- https://github.com/folke/snacks.nvim/discussions/468
          ivy = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.5,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
            },
          },
        },
        previewers = {
          diff = {
            builtin = true, -- use Neovim for previewing diffs (true) or use an external tool (false)
            cmd = { "delta" }, -- example to show a diff with delta
          },
          man_pager = "nvim", ---@type string? MANPAGER env to use for `man` preview
        },
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              -- I'm used to scrolling like this in LazyGit
              ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 80,
          },
        },
      }
      return opts
    end,
    -- stylua: ignore
    keys = {
    -- Top Pickers & Explorer
    -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Snacks Smart Find Files" },
    -- {"<c-n>", function () Snacks.picker.explorer({cwd = require("utils").workspace()}, {desc = "General File Finder"}) end},
  { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Snacks Notification History" },
    -- find
    { "<leader>fa", function() Snacks.picker.files({ cwd = vim.fn.stdpath('config'), preset = "ivy" })end, desc = "Snacks Find Config" },
    { "<leader>fb", function() Snacks.picker.buffers({ preset = "ivy" }) end, desc = "Snacks Buffers" },
    { "<leader>ff", function() Snacks.picker.files({ preset = "ivy", cwd = require("utils").workspace() }) end, desc = "Snacks Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files({ preset = "ivy" }) end, desc = "Snacks Find Git Files" },
    { "<leader>fh", function() Snacks.picker.highlights({ preset = "ivy" }) end, desc = "Snacks Highlights" },
    { "<leader>fk", function() Snacks.picker.keymaps({ preset = "ivy" }) end, desc = "Snacks Keymaps" },
    { "<leader>fm", function() Snacks.picker.marks({preset = "ivy"}) end, desc = "Snacks Marks" },
    { "<leader>fq", function() Snacks.picker.qflist({preset = "ivy"}) end, desc = "Snakcs Quickfix List" },
    { "<leader>ft", function ()
      Snacks.picker.colorschemes(require("utils.select-themes"))
    end, desc = "Snacks Colorschemes" },
    { "<leader>fu", function() Snacks.picker.undo({ preset = "ivy" }) end, desc = "Snacks Undo History" },
    { "<leader>fw", function() Snacks.picker.grep({cwd = require("utils").workspace(), preset = "ivy"}) end, desc = "Snacks Picker Grep" },
    { "<leader>fW", function() Snacks.picker.grep_word({preset = "ivy"}) end, desc = "Visual selection or word", mode = { "n", "x" } },
    {"<leader>fp", function ()
      Snacks.picker.projects(require('utils.projects'))
    end, desc = "Snacks Find Projects "},
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches( { cwd = find_git_root(), preset="ivy" }  ) end, desc = "Snacks Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log( { cwd = find_git_root(), preset="ivy"} ) end, desc = "Snacks Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line( { cwd = find_git_root(), preset="ivy" } ) end, desc = "Snacks Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status( { cwd = find_git_root(), preset="ivy" } ) end, desc = "Snacks Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash( { cwd = find_git_root(), preset="ivy" } ) end, desc = "Snacks Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff( { cwd = find_git_root(), preset="ivy" } ) end, desc = "Snacks Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file( { cwd = find_git_root(), preset="ivy" } ) end, desc = "Snakcs Git Log File" },
    -- Grep
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Snacks Buffer Lines" },

    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Snacks Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds({preset = "ivy"}) end, desc = "Snacks Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Snacks Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Snacks Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Snacks Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics({preset = "ivy"}) end, desc = "Snacks Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer({preset = "ivy"}) end, desc = "Snacks Buffer Diagnostics" },
    { "<leader>sH", function() Snacks.picker.help() end, desc = "Snacks Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Snacks Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Snacks Jumps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Snacks Location List" },
    { "<leader>sm", function() Snacks.picker.man() end, desc = "Snacks Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Snacks Search for Plugin Spec" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Snacks Resume" },
    -- LSP
    { "<leader>ls", function() Snacks.picker.lsp_symbols({preset = "ivy"}) end, desc = "LSP Symbols" },
    { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols({preset = "ivy"}) end, desc = "LSP Workspace Symbols" },
  },
  },
  -- Flash integration
  {
    "folke/flash.nvim",
    specs = {
      {
        "folke/snacks.nvim",
        opts = {
          picker = {
            win = {
              input = {
                keys = {
                  ["<a-s>"] = { "flash", mode = { "n", "i" } },
                  ["s"] = { "flash" },
                },
              },
            },
            actions = {
              flash = function(picker)
                require("flash").jump {
                  pattern = "^",
                  label = { after = { 0, 0 } },
                  search = {
                    mode = "search",
                    exclude = {
                      function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                      end,
                    },
                  },
                  action = function(match)
                    local idx = picker.list:row2idx(match.pos[1])
                    picker.list:_move(idx, true, true)
                  end,
                }
              end,
            },
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
  -- stylua: ignore
  keys = {
    { "<leader>fd", function() Snacks.picker.todo_comments() end, desc = "Snacks Todo:" },
    { "<leader>fD", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Snacks Todo/Fix/Fixme" },
  },
    --
  },
  {
    "folke/trouble.nvim",
    lazy = true,
    specs = {
      {
        "folke/snacks.nvim",
        opts = function(_, opts)
          -- 使用一个 local 变量延迟引用，或者直接在 actions 里写 function
          opts.picker = opts.picker or {}
          opts.picker.actions = opts.picker.actions or {}

          -- 这种写法不会在启动时触发 require
          opts.picker.actions.trouble_open = function(...)
            return require("trouble.sources.snacks").actions.trouble_open(...)
          end

          return opts
        end,
      },
    },
  },
}
