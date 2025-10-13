return {
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function()
  --     -- Customization for Pmenu
  --     vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
  --     vim.api.nvim_set_hl(0, "Pmenu", { fg = "#64B5F6", bg = "#1a1d23" })
  --     vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })
  --     -- blue
  --     vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
  --     vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "onsails/lspkind.nvim",
      -- "hrsh7th/cmp-cmdline",
    },

    opts = {
      completion = {
        -- auto select first item
        completeopt = "menu,menuone,preview,noinsert",
      },
      window = {
        completion = {
          -- require("cmp").config.window.bordered(),
          -- border = "rounded",
          winhighlight = "PmenuSel:PmenuSel,Normal:Pmenu,FloatBorder:Pmenu,Search:None",
          -- border = borderMenu "CmpBorder",
          border = "rounded",
          scrollbar = true,
          scrolloff = 1,
          col_offset = 1,
          side_padding = 1,
          -- pumwidth = 30,
          -- pumheight = 20,
          -- maxwidth = 30,
          -- maxheight = 20,
        },
        documentation = {
          -- border = "rounded",
          border = "rounded",
          col_offset = 0,
          side_padding = 0,
          winhighlight = "Normal:Pmenu,NormalFloat:NormalFloat,FloatBorder:Pmenu",
        },
      },
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          local function get_icon_provider()
            local _, mini_icons = pcall(require, "mini.icons")
            if _G.MiniIcons then return function(kind) return mini_icons.get("lsp", kind or "") end end
            local lspkind_avail, lspkind = pcall(require, "lspkind")
            if lspkind_avail then return function(kind) return lspkind.symbolic(kind, { mode = "symbol" }) end end
          end

          local icon_provider = get_icon_provider()
          local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
          local color_item = highlight_colors_avail and highlight_colors.format(entry, { kind = item.kind })
          if icon_provider then
            local icon = icon_provider(item.kind)
            if icon then item.kind = icon .. "\t" .. item.kind end
          end

          if color_item and color_item.abbr and color_item.abbr_hl_group then
            item.kind, item.kind_hl_group = color_item.abbr, color_item.abbr_hl_group
          end

          local widths = {
            abbr = 35,
            menu = 25,
          }

          for key, width in pairs(widths) do
            -- item[key] = truncateString(trim(item[key]), width) .. "…"
            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
              item[key] = string.sub(item[key], 1, width - 1) .. "…"
            end
          end
          return item
        end,
      },
    },
    config = function(_, opts) require("cmp").setup(opts) end,
  },
}
