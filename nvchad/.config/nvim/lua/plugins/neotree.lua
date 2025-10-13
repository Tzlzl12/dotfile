local get_icon = require("utils").get_icon
local is_available = require("utils").is_available

local is_git_repo = require("utils").is_git_repo

--
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    specs = {
      { "nvim-lua/plenary.nvim", lazy = true },
      { "MunifTanjim/nui.nvim", lazy = true },
      { "nvim-tree/nvim-tree.lua", enabled = false },
    },
    event = "VeryLazy",
    cmd = "Neotree",
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require "neo-tree"
            end
          end
        end,
      })
    end,
    opts_extend = { "sources" },
    opts = function()
      -- local astro, get_icon = require "astrocore", require("astroui").get_icon
      local git_available = vim.fn.executable "git" == 1
      local sources = {
        { source = "filesystem", display_name = get_icon "FolderClosed" .. " File" },
        -- { source = "buffers", display_name = get_icon("DefaultFile", 1, true) .. "Bufs" },
        -- { source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
      }
      if git_available then
        if is_git_repo() then
          table.insert(sources, 2, { source = "git_status", display_name = get_icon "Git" .. " Git" })
        end
      end
      local opts = {
        enable_git_status = git_available,
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "buffers", git_available and "git_status" or nil },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = sources,
        },
        default_component_configs = {
          indent = {
            padding = 0,
            expander_collapsed = get_icon "FoldClosed",
            expander_expanded = get_icon "FoldOpened",
          },
          icon = {
            folder_closed = get_icon "FolderClosed",
            folder_open = get_icon "FolderOpen",
            folder_empty = get_icon "FolderEmpty",
            folder_empty_open = get_icon "FolderEmpty",
            default = get_icon "ft",
          },
          modified = { symbol = get_icon "FileModified" },
          git_status = {
            symbols = {
              added = get_icon "GitAdd",
              deleted = get_icon "GitDelete",
              modified = get_icon "GitChange",
              renamed = get_icon "GitRenamed",
              untracked = get_icon "GitUntracked",
              ignored = get_icon "GitIgnored",
              -- unstaged = get_icon "GitUnstaged",
              unstaged = "",
              staged = get_icon "GitStaged",
              conflict = get_icon "GitConflict",
            },
          },
        },
        commands = {
          -- system_open = function(state)
          --   -- TODO: remove deprecated method check after dropping support for neovim v0.9
          --
          --   (vim.ui.open)(state.tree:get_node():get_id())
          -- end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if node:has_children() and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                if node.type == "file" then
                  state.commands.open(state)
                else
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            else -- if has no children
              state.commands.open(state)
            end
          end,
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local vals = {
              ["BASENAME"] = modify(filename, ":r"),
              ["EXTENSION"] = modify(filename, ":e"),
              ["FILENAME"] = filename,
              ["PATH (CWD)"] = modify(filepath, ":."),
              ["PATH (HOME)"] = modify(filepath, ":~"),
              ["PATH"] = filepath,
              ["URI"] = vim.uri_from_fname(filepath),
            }

            local options = vim.tbl_filter(function(val)
              return vals[val] ~= ""
            end, vim.tbl_keys(vals))
            if vim.tbl_isempty(options) then
              vim.notify("No values to copy", vim.log.levels.WARN)
              -- require("noice").notify("No values to copy", vim.log.levels.WARN)
              return
            end
            table.sort(options)
            vim.ui.select(options, {
              prompt = "Choose to copy to clipboard:",
              format_item = function(item)
                return ("%s: %s"):format(item, vals[item])
              end,
            }, function(choice)
              local result = vals[choice]
              if result then
                vim.notify(("Copied: `%s`"):format(result), vim.log.levels.INFO)
                -- require("noice").notify(("Copied: `%s`"):format(result))
                vim.fn.setreg("+", result)
              end
            end)
          end,
        },
        window = {
          width = 25,
          mappings = {
            -- ["<S-CR>"] = "system_open",
            ["<Space>"] = false,
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            -- O = "system_open",
            Y = "copy_selector",
            h = "parent_or_close",
            l = "child_or_open",
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ["<C-J>"] = "move_cursor_down",
            ["<C-K>"] = "move_cursor_up",
          },
        },
        filesystem = {
          follow_current_file = { enabled = true },
          filtered_items = { hide_gitignored = git_available },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_)
              vim.opt_local.signcolumn = "auto"
              vim.opt_local.foldcolumn = "0"
            end,
          },
        },
      }

      if is_available "telescope.nvim" then
        opts.commands.find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          require("telescope.builtin").find_files { cwd = path }
        end
        opts.window.mappings.F = "find_in_dir"
      end

      -- if astro.is_available "toggleterm.nvim" then
      --   local function toggleterm_in_direction(state, direction)
      --     local node = state.tree:get_node()
      --     local path = node.type == "file" and node:get_parent_id() or node:get_id()
      --     require("toggleterm.terminal").Terminal:new({ dir = path, direction = direction }):toggle()
      --   end
      --   local prefix = "T"
      --   ---@diagnostic disable-next-line: assign-type-mismatch
      --   opts.window.mappings[prefix] =
      --     { "show_help", nowait = false, config = { title = "New Terminal", prefix_key = prefix } }
      --   for suffix, direction in pairs { f = "float", h = "horizontal", v = "vertical" } do
      --     local command = "toggleterm_" .. direction
      --     opts.commands[command] = function(state)
      --       toggleterm_in_direction(state, direction)
      --     end
      --     opts.window.mappings[prefix .. suffix] = command
      --   end
      -- end

      return opts
    end,
  },
}
