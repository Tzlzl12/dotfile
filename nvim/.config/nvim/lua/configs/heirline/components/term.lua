return {
	-- icon = ' ', -- 
	{
		provider = function()
			local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
			return " " .. tname
		end,
		hl = { fg = "blue", bold = true },
	},
	{ provider = " - " },
	{
		provider = function()
			return vim.b.term_title
		end,
	},
	{
		provider = function()
			-- local id = require("terminal"):current_term_index()
			local id = "Float Term"
			return " " .. (id or "Exited")
		end,
		hl = { bold = true, fg = "blue" },
	},
}
