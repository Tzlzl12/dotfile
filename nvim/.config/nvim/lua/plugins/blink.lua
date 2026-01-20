local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local menu_cols = { { "label" }, { "kind_icon" }, { "kind" } }
local highlights = {
  BlinkCmpMenuSelection = { bg = "#a6e3a1", fg = "#fb4934" },
  BlinkCmpKindEnum = { fg = "#fb4934" },
  BlinkCmpKindFile = { fg = "#d65d0e" },
  BlinkCmpKindText = { fg = "#b8bb26" },
  BlinkCmpKindUnit = { fg = "#83a598" },
  BlinkCmpGhostText = { fg = "#928374" },
  BlinkCmpKindClass = { fg = "#83a598" },
  BlinkCmpKindColor = { fg = "#fb4934" },
  BlinkCmpKindEvent = { fg = "#fb4934" },
  BlinkCmpKindField = { fg = "#fabd2f" },
  BlinkCmpKindValue = { fg = "#d3869b" },
  BlinkCmpKindFolder = { fg = "#d65d0e" },
  BlinkCmpKindMethod = { fg = "#8ec07c" },
  BlinkCmpKindModule = { fg = "#83a598" },
  BlinkCmpKindStruct = { fg = "#83a598" },
  BlinkCmpMenuBorder = { fg = "#665c54" },
  BlinkCmpKindKeyword = { fg = "#fabd2f" },
  BlinkCmpKindSnippet = { fg = "#b8bb26" },
  BlinkCmpKindConstant = { fg = "#d3869b" },
  BlinkCmpKindFunction = { fg = "#8ec07c" },
  BlinkCmpKindOperator = { fg = "#8ec07c" },
  BlinkCmpKindProperty = { fg = "#fabd2f" },
  BlinkCmpKindVariable = { fg = "#d3869b" },
  Pmenu = { fg = "#64B5F6", bg = "NONE" },
  PmenuSel = { fg = "#61afef", bg = "NONE" },
  PmenuTumb = { bg = "NONE" },
}

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
          require("mini.pairs").setup(opts)
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
        -- per_filetype = {
        --   codecompanion = {
        --     "codecompanion", -- 必须有这个
        --     "lsp",
        --     "path",
        --     "snippets",
        --     "buffer", -- 手动继承 default，避免空菜单
        --   },
        -- },
        providers = {
          -- stylua: ignore 
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90, -- 显示优先级高于 lsp
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 100, -- 显示优先级高于 lsp
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- 显示优先级高于 lsp
            opts = {},
          },
          avante_shortcuts = {
            name = "avante_shortcuts",
            module = "blink.compat.source",
            score_offset = 1000, -- 显示优先级高于 lsp
            opts = {},
          },
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
            local codeium = require "neocodeium"
            if codeium.visible() then
              codeium.accept()
              return true
            end
            -- if require("codeium.virtual_text").get_current_completion_item() then
            --   vim.api.nvim_input(require("codeium.virtual_text").accept())
            --   return true
            -- end
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
      for group, colors in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, colors)
      end

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
    dependencies = {
      "olimorris/codecompanion.nvim", -- 重要：加这个，让 blink 能加载 codecompanion source
    },
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
