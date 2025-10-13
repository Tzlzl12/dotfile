return {

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = vim.g.nvchad_notify.noice,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    },
    opts = {
      lsp = {
        progress = { enabled = not vim.g.nvchad_notify.fidget },
        hover = {
          silent = true,
          enabled = false,
          opts = {
            border = "rounded",
            max_width = 20,
            max_height = 20,
          },
        },
        -- signature = {
        --   enabled = false,
        -- },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = false, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          opts = {}, -- merged with defaults from documentation
        },
        message = {
          enabled = true,
          view = "mini",
          format = "markdown",
          opts = {},
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },

      cmdline = {
        view = "cmdline",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "General Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "General Scroll Backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    enabled = vim.g.nvchad_notify.fidget,
    opts = {
      progress = {
        display = {
          done_icon = "",
        },
      },
      notification = {
        window = {
          winblend = 0,
          x_padding = 0,
        },
      },
    },
    config = function(_, opts)
      local function fidget_print(...)
        local args = { ... }
        local message = table.concat(vim.tbl_map(vim.inspect, args), " ")
        require("fidget").notify(message, vim.log.levels.INFO)
      end

      _G.print = fidget_print
      require("fidget").setup(opts)
      vim.notify = require("fidget.notification").notify
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    -- enabled = function()
    --   return LazyVim.pick.want() == "telescope"
    -- end,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
}
