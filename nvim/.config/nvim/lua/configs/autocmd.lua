vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text", -- 描述，可选
	pattern = "*", -- 适用于所有文件
	callback = function()
		(vim.hl or vim.highlight).on_yank() -- 调用高亮方法
	end,
})
-- 在主题改变时, 自动重新加载语法高亮
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#f7768e" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#7aa2f7" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff9e64" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#bb9af7" })
		vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#7dc4e4" })
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "IceAfter colorscheme",
	callback = function()
		local function should_trigger()
			-- 排除dashboard和空缓冲区
			return vim.bo.filetype ~= "dashboard" and vim.api.nvim_buf_get_name(0) ~= ""
		end

		local function trigger()
			-- 触发你的自定义加载事件
			vim.api.nvim_exec_autocmds("User", { pattern = "IceLoad" })
		end

		-- 如果当前条件满足，立即触发
		if should_trigger() then
			trigger()
			return
		end

		-- 否则等待进入合适的缓冲区后再触发
		local ice_load
		ice_load = vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				if should_trigger() then
					trigger()
					vim.api.nvim_del_autocmd(ice_load) -- 触发后删除自动命令
				end
			end,
		})
	end,
})
-- 进入 Visual 模式时启用 listchars
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[vV\x16]", -- 匹配进入 Visual 模式
	callback = function()
		vim.opt.list = true -- 启用 listchars
	end,
})

-- 离开 Visual 模式时禁用 listchars
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[^vV\x16]", -- 匹配离开 Visual 模式
	callback = function()
		vim.opt.list = false -- 禁用 listchars
	end,
})

local blink_inline = vim.api.nvim_create_augroup("BlinkCmpCopilot", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = blink_inline,
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		require("codeium.virtual_text").clear()
		vim.b.copilot_suggestion_hidden = true
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = blink_inline,
	pattern = "BlinkCmpMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})
