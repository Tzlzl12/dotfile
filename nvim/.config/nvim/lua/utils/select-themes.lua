local M = {}
local colorscheme = require("utils.themes").colorscheme

-- 重新加载主题
local function reload_theme(name)
	colorscheme(name, false)
end

-- Picker 配置
M.title = "󱥚 Set Colorscheme"
M.preset = "vscode"
M.format = "text"

M.finder = function()
	local items = {}

	if Ice and Ice.colorschemes then
		for name, _ in pairs(Ice.colorschemes) do
			-- 过滤掉 astrotheme
			if name ~= "astrotheme" then
				table.insert(items, { text = name })
			end
		end
	end

	return items
end

M.on_change = function(picker, item)
	if item and item.text then
		reload_theme(item.text)
	end
end

M.preview = function(picker, item)
	return ""
end

M.confirm = function(picker, item)
	picker:close()

	if item and item.text then
		vim.schedule(function()
			reload_theme(item.text)

			local colorscheme_cache = vim.fs.joinpath(vim.fn.stdpath("data"), "colorscheme")
			local f = io.open(colorscheme_cache, "w")
			if f then
				f:write(item.text)
				f:close()
			end
		end)
	end
end

return M
