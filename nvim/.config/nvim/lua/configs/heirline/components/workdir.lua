local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local icons = require("configs.heirline.common")
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local workdir_color = { bg = "#f38ba8" }
return utils.surround({ separators.rounded_left, separators.rounded_right }, workdir_color.bg, {
	init = function(self)
		self.icon = " "
		self.cwd = vim.fn.fnamemodify(vim.uv.cwd() or "~", ":t")
		if not conditions.width_percent_below(#self.cwd, 0.27) then
			self.cwd = vim.fn.pathshorten(self.cwd)
		end
	end,
	hl = { fg = "gray", bg = workdir_color.bg, bold = true },
	on_click = {
		callback = function()
			vim.cmd("Neotree toggle")
		end,
		name = "heirline_workdir",
	},
	flexible = 1,
	{
		provider = function(self)
			-- local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return self.icon .. self.cwd
		end,
	},
	{
		provider = function(self)
			local cwd = vim.fn.pathshorten(self.cwd)
			local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return self.icon .. cwd .. trail .. " "
		end,
	},
	{
		provider = "",
	},
})
