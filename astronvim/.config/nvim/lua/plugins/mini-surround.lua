return {
  {
    "echasnovski/mini.surround",
    recommended = true,
    -- dependencies = {
    --   {
    --     "AstroNvim/astrocore",
    --     opts = function(_, opts)
    --       -- local surround = require "mini.surround"
    --       local maps = opts.mappings
    --       local prefix = "gs"
    --       maps.n[prefix .. "t"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer" }
    --
    --       maps.n[prefix .. "a"] = {
    --         -- surround.add "n",
    --         desc = "Add Surrounding",
    --       }
    --       maps.n[prefix .. "d"] = {
    --         -- surround.delete(),
    --         desc = "Add Surrounding",
    --       }
    --       maps.n[prefix .. "f"] = {
    --         -- surround.find(),
    --         desc = "Add Surrounding",
    --       }
    --       maps.n[prefix .. "h"] = {
    --         -- surround.highlight(),
    --         desc = "Add Surrounding",
    --       }
    --       maps.n[prefix .. "r"] = {
    --         -- surround.replace(),
    --         desc = "Add Surrounding",
    --       }
    --       maps.n[prefix .. "n"] = {
    --         -- surround.update_n_lines(),
    --         desc = "Add Surrounding",
    --       }
    --     end,
    --   },
    -- },

    -- keys = function(_, keys)
    --   -- Populate the keys based on the user's options
    --   local opts = {
    --     mappings = {
    --       add = "gsa", -- Add surrounding in Normal and Visual modes
    --       delete = "gsd", -- Delete surrounding
    --       find = "gsf", -- Find surrounding (to the right)
    --       find_left = "gsF", -- Find surrounding (to the left)
    --       highlight = "gsh", -- Highlight surrounding
    --       replace = "gsr", -- Replace surrounding
    --       update_n_lines = "gsn", -- Update `n_lines`
    --     },
    --   }
    --   local mappings = {
    --     { opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
    --     { opts.mappings.delete, desc = "Delete Surrounding" },
    --     { opts.mappings.find, desc = "Find Right Surrounding" },
    --     { opts.mappings.find_left, desc = "Find Left Surrounding" },
    --     { opts.mappings.highlight, desc = "Highlight Surrounding" },
    --     { opts.mappings.replace, desc = "Replace Surrounding" },
    --     { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
    --   }
    --   mappings = vim.tbl_filter(function(m) return m[1] and #m[1] > 0 end, mappings)
    --   return vim.list_extend(mappings, keys)
    -- end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
}
