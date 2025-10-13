-- Type annotations for LSP support (autocompletion, hover hints)
---@class Base46Table
---@field base_30 table<string, string>
---@field base_16 table<string, string>
---@field polish_hl table<string, table>
---@field type string
local M = {}

-- Import color utility (if needed)
-- local color = require "astrotheme.lib.color"

-- UI Colors (base_30)
M.base_30 = {
  white = "#ADB0BB",
  black = "#1A1D23", -- theme bg
  darker_black = "#16181D", -- 6% darker than black
  black2 = "#1E222A", -- 6% lighter than black
  one_bg = "#23272F", -- 10% lighter than black
  one_bg2 = "#2A2E36", -- 6% lighter than one_bg
  one_bg3 = "#30343C", -- 6% lighter than one_bg2
  grey = "#494D56", -- 40% lighter than black
  grey_fg = "#595C66", -- 10% lighter than grey
  grey_fg2 = "#696C76", -- 5% lighter than grey
  light_grey = "#797D87",
  red = "#FF838B",
  baby_pink = "#F8747E",
  pink = "#DD97F1",
  line = "#2A2E36", -- 15% lighter than black
  green = "#87C05F",
  vibrant_green = "#75AD47",
  nord_blue = "#5EB7FF",
  blue = "#50A4E9",
  seablue = "#4AC2B8",
  yellow = "#DFAB25",
  sun = "#F5983A",
  purple = "#CC83E3",
  dark_purple = "#A36AC7",
  teal = "#00B298",
  orange = "#EB8332",
  cyan = "#4AC2B8",
  statusline_bg = "#111317",
  lightbg = "#21242A",
  pmenu_bg = "#50A4E9",
  folder_bg = "#5EB7FF",
}

-- Base16 Colors (Syntax)
M.base_16 = {
  base00 = "#1A1D23", -- Background
  base01 = "#23272F", -- Lighter bg
  base02 = "#2A2E36", -- Selection bg
  base03 = "#3A3E47", -- Comments
  base04 = "#9B9FA9", -- Dark foreground
  base05 = "#ADB0BB", -- Default foreground
  base06 = "#E0E0Ee", -- Light foreground
  base07 = "#FFFFFF", -- Light bg (rarely used)
  base08 = "#FF838B", -- Variables, XML tags
  base09 = "#F5983A", -- Integers, Booleans
  base0A = "#DFAB25", -- Classes, Search bg
  base0B = "#87C05F", -- Strings
  base0C = "#4AC2B8", -- Regex, Escape chars
  base0D = "#5EB7FF", -- Functions, Methods
  base0E = "#DD97F1", -- Keywords
  base0F = "#595C66", -- Deprecated
}

-- Optional Highlight Overrides
M.polish_hl = {
  defaults = {
    Comment = { fg = M.base_16.base03, italic = true, bg = "NONE" },
    ["@comment"] = { link = "Comment" }, -- Treesitter support
  },
  treesitter = {
    ["@variable"] = { fg = M.base_30.white },
    ["@property"] = { fg = M.base_16.base_0D }, -- Blue for properties
  },
}

-- Theme Type (dark/light)
M.type = "dark"

-- Override with user customizations (if any)
M = require("base46").override_theme(M, "astro")

return M
