local Align = { provider = "%=" }
local Space = { provider = " " }
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local components = require("configs.heirline.components")
local icons = require("configs.heirline.common")
local separators = require("configs.heirline.common").separators
local CloseButton = {
	condition = function(self)
		return not vim.bo.modified
	end,
	update = { "WinNew", "WinClosed", "BufEnter" },
	{ provider = " " },
	{
		provider = icons.close,
		hl = { fg = "gray" },
		on_click = {
			callback = function(_, minwid)
				vim.api.nvim_win_close(minwid, true)
			end,
			minwid = function()
				return vim.api.nvim_get_current_win()
			end,
			name = "heirline_winbar_close_button",
		},
	},
}

local WinBar = {
	fallthrough = false,
	-- {
	-- 	condition = function()
	-- 		return conditions.buffer_matches({
	-- 			buftype = { "nofile", "prompt", "help", "quickfix" },
	-- 			filetype = { "^git.*", "fugitive" },
	-- 		})
	-- 	end,
	-- 	init = function()
	-- 		vim.opt_local.winbar = nil
	-- 	end,
	-- },
	{
		condition = function()
			return conditions.buffer_matches({ buftype = { "terminal" } })
		end,
		utils.surround({ "", separators.rounded_right }, "dark_red", {
			components.File.FileType,
			Space,
			components.TerminalName,
			CloseButton,
		}),
	},
	utils.surround({ "", separators.rounded_right }, "bright_bg", {
		fallthrough = false,
		{
			condition = conditions.is_not_active,
			{
				hl = { fg = "bright_fg", force = true },
				components.File.FileNameBlock,
			},
			CloseButton,
		},
		{
			-- provider = "      ",
			-- Navic,
			{ provider = "%<" },
			Align,
			components.File.FileNameBlock,
			CloseButton,
		},
	}),
}

return WinBar
