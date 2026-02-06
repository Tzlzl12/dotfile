return {
  "Isrothy/neominimap.nvim",
  event = "BufReadPre",
  init = function()
    local get_icon = require("utils").get_icon
    vim.api.nvim_set_hl(0, "NeominimapCursorLine", { fg = "None", bg = "#665c54" })

    vim.g.neominimap = {
      auto_enale = true,
      layout = "split",
      split = {
        minimap_width = 15,
        close_if_last_window = true,
      },
      float = {
        minimap_width = 12,
        -- z_index = 0,
      },
      -- exclude_filetypes = {},
      -- exclude_buftypes = {},
      click = {
        enabled = true,
      },
      diagnostic = {
        icon = {
          ERROR = get_icon("dia").Error,
          WARN = get_icon("dia").Warn,
          INFO = get_icon("dia").Info,
          HINT = get_icon("dia").Hint,
        },
      },
      git = {
        icon = {
          add = get_icon "GitAdd",
          change = get_icon "GitChange",
          delete = get_icon "GitDelete",
        },
      },
    }
  end,
}
