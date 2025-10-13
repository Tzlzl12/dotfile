if false then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)

-- as this provides autocomplete and documentation while editing
---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "astrodark",
    palettes = {
      astrodark = { -- Extend or modify astrodarks palette colors
        syntax = {
          comments = "#4a4a4a", -- Overrides astrodarks comment color.
        },
      },
    },
    -- colorscheme = "tokyonight-storm",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
        RainbowRed = { fg = "#FF6F61" },
        RainbowYellow = { fg = "#FFB74D" },
        RainbowBlue = { fg = "#64B5F6" },
        RainbowOrange = { fg = "#FF8A65" },
        RainbowGreen = { fg = "#A5D6A7" },
        RainbowViolet = { fg = "#BA68C8" },
        RainbowCyan = { fg = "#80DEEA" },
        CmpItemMenu = { fg = "#C792EA", bg = "NONE", bold = true },
        CmpItemAbbrMatch = { bg = "NONE", fg = "#569CD6", bold = true },
        CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        LineNr = { fg = "#80deea" },
        LineNrBelow = { fg = "#64B5F6" },
        -- -- LineNrAbove = { fg = "NONE" },
        -- -- Normal = { bg = "#000000" },
        FzfLuaBorder = { bg = "NONE" },
        FzfLuaTitle = { bg = "NONE" },
        FzfLuaBackdrop = { bg = "NONE" },
        FzfLuaHeaderText = { bg = "NONE" },
        FzfLuaTabTitle = { bg = "NONE" },
        FzfLuaFzfBorder = { fg = "#569cd6", bg = "NONE" },

        TelescopeBorder = { fg = "#569cd6", bg = "NONE" },
        TelescopeNormal = { bg = "NONE" },
        TelescopePreviewNormal = { bg = "NONE" },
        TelescopeResultsNormal = { bg = "NONE" },
        TelescopePromptNormal = { bg = "NONE" },
        TelescopePromptBorder = { bg = "NONE" },
        TelescopePromptTitle = { fg = "#0f94d2", bg = "NONE" },

        TelescopeSelectionCaret = { bg = "NONE" },

        TelescopeMatching = { fg = "#dd4814", bg = "NONE" },

        TelescopePromptPrefix = { fg = "#ff8a65" },

        TelescopePreviewTitle = { fg = "#0f94d2", bg = "NONE" },

        TelescopePreviewBorder = { fg = "#0f94d2", bg = "NONE" },

        TelescopeResultsTitle = { fg = "#0f94d2", bg = "NONE" },

        TelescopeResultsBorder = { fg = "#0f94d2", bg = "NONE" },

        -- --
        -- FzfLuaPreviewNormal = { bg = "NONE" },
        -- FzfLuaPreviewBorder = { bg = "NONE" },
        -- FzfLuaPreviewTitle = { fg = "#f9906f", bg = "NONE" },
        -- FzfLuaSearch = { bg = "NONE" },
        -- FzfLuaScrollBorderEmpty = { bg = "NONE" },
        -- FzfLuaScrollBorderFull = { bg = "NONE" },
        -- FzfLuaScrollFloatEmpty = { bg = "NONE" },
        -- FzfLuaScrollFloatFull = { bg = "NONE" },
        TabLineSel = { bg = "#1e2220" },
        --
        -- -- CMP
        CursorLine = { bg = "#1e2220", fg = "NONE" },
        NormalFloat = { bg = "NONE" },
        WinBarNC = { bg = "NONE" },
        StatusLine = { bg = "NONE" },
        --
        Pmenu = { fg = "#64B5F6", bg = "NONE" },
        PmenuTumb = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },
        FloatFooter = { bg = "NONE" },
        TabLine = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        Title = { bg = "NONE" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
