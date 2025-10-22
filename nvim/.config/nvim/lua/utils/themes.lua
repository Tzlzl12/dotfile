local M = {}

local transperent_highlight = {
	NormalFloat = { bg = "NONE" },
	WinBarNC = { bg = "NONE" },
	StatusLine = { bg = "NONE" },

	FloatBorder = { bg = "NONE" },
	FloatTitle = { bg = "NONE" },
	FloatFooter = { bg = "NONE" },
	TabLine = { bg = "NONE" },
	TabLineFill = { bg = "NONE" },
	Title = { bg = "NONE" },

	NotifyBackground = { bg = "#64B5F6" },
}

local function set_highlight(hl)
	for group, colors in pairs(hl) do
		vim.api.nvim_set_hl(0, group, colors)
	end
end
-- 主题切换核心函数
M.colorscheme = function(colorscheme_name, transparent)
	Ice.colorscheme = colorscheme_name

	local colorscheme = Ice.colorschemes[colorscheme_name]
	if not colorscheme then
		vim.notify(colorscheme_name .. " is not a valid color scheme!", vim.log.levels.ERROR)
		return
	end

	-- require("lazy.core.loader").colorscheme(colorscheme.name)
	vim.cmd("colorscheme " .. colorscheme.name)
	vim.o.background = colorscheme.background
	set_highlight(transperent_highlight)

	vim.api.nvim_set_hl(0, "Visual", { reverse = true })
	vim.api.nvim_exec_autocmds("User", { pattern = "IceAfter colorscheme" })
end

return M
