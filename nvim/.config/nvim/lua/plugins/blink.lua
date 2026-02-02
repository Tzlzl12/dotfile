local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
local function create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(CREATE_UNDO, "n", false)
  end
end

local menu_cols = { { "label" }, { "kind_icon" }, { "kind" } }
local highlights = {}

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    -- version = "*",
    build = "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    dependencies = {
      -- "rafamadriz/friendly-snippets",
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {
          ls = {
            lua_ls = {
              -- Maybe you want to dim arguments a bit.
              arguments_hl = "@comment",
            },
            ["rust-analyzer"] = {
              -- Such as (as Iterator), (use std::io).
              extra_info_hl = "@comment",
              -- Similar to the same setting of gopls.
              align_type_to_right = true,
              -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
              preserve_type_when_truncate = true,
            },
            clangd = {
              -- Such as "From <stdio.h>".
              extra_info_hl = "@comment",
              -- Similar to the same setting of gopls.
              align_type_to_right = true,
              -- the hl group of leading dot of "•std::filesystem::permissions(..)"
              import_dot_hl = "@comment",
              -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
              preserve_type_when_truncate = true,
            },
            zls = {
              -- Similar to the same setting of gopls.
              align_type_to_right = true,
            },
          },
        },
      },
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        lazy = true,
        opts = {},
        -- version = "*",
      },
      {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        opts = {
          modes = { insert = true, command = true, terminal = false },
          -- skip autopair when next character is one of these
          skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
          -- skip autopair when the cursor is inside these treesitter nodes
          skip_ts = { "string" },
          -- skip autopair when next character is closing pair
          -- and there are more closing pairs than opening pairs
          skip_unbalanced = true,
          -- better deal with markdown code blocks
          markdown = true,
        },
        config = function(_, opts)
          -- require("mini.pairs").setup(opts)
          local pairs = require "mini.pairs"
          pairs.setup {}

          vim.keymap.set("i", "<CR>", function()
            return pairs.cr()
          end, { expr = true, replace_keycodes = true })
          pairs.setup(opts)
        end,
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = "default",
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = { enabled = false },
          -- experimental auto-brackets support
          -- auto_brackets = {
          --   enabled = true,
          -- },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
          border = "single",
          min_width = 15,
          max_height = 10,
          draw = {
            columns = menu_cols,
            gap = 2,
            treesitter = { "lsp" },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                text = function(ctx)
                  -- default kind icon
                  local icon = require("configs.icons").icons.kinds[ctx.kind] or ""
                  return icon .. ctx.icon_gap
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            border = "single",
            direction_priority = {
              menu_north = { "s", "w" }, -- appearent in menu north
              menu_south = { "n", "w" },
            },
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      -- experimental signature help support

      sources = {
        default = {
          "lsp",
          "snippets",
          "path",
          "buffer",
        },
        providers = {
          -- stylua: ignore 
          lsp = { score_offset = 10 },
          path = { min_keyword_length = 0, score_offset = 3 },
          -- snippets = { score_offset = 3 },
          buffer = { min_keyword_length = 3, max_items = 5 },
          --
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust",
        sorts = {
          -- "defaults",
          "exact",
          "score",
          "sort_text",
        },
      },
      cmdline = {
        enabled = true,
        completion = { ghost_text = { enabled = true } },
      },
      keymap = {
        preset = "enter",

        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-N>"] = { "select_next", "show" },
        ["<C-P>"] = { "select_prev", "show" },
        ["<C-J>"] = { "select_next", "fallback" },
        ["<C-K>"] = { "select_prev", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up" },
        ["<C-d>"] = { "scroll_documentation_down" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          "snippet_forward",
          "accept",
          function()
            -- if require("copilot.client").is_disabled() then
            if not vim.g.use_copilot then
              local codeium = require "neocodeium"
              if codeium.visible() then
                create_undo()
                codeium.accept()
                return true
              end
            else
              local copilot = require "copilot.suggestion"
              if copilot.is_visible() then
                create_undo()
                copilot.accept()
                return true
              end
            end
          end,
          function(cmp)
            if has_words_before() and vim.api.nvim_get_mode().mode == "c" then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          "snippet_backward",
          "select_prev",
          function(cmp)
            if vim.api.nvim_get_mode().mode == "c" then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- add icons
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons =
        vim.tbl_extend("force", opts.appearance.kind_icons or {}, require("configs.icons").icons.kinds)
      require("blink.cmp").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree", -- 监听的文件类型
        callback = function()
          vim.b.completion = false
        end,
      })
    end,
  },

  -- lazydev
  {
    "saghen/blink.cmp",
    lazy = true,
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    -- dependencies = {
    --   "olimorris/codecompanion.nvim", -- 重要：加这个，让 blink 能加载 codecompanion source
    -- },
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },

      keymap = { preset = "super-tab" },
    },
  },
}
