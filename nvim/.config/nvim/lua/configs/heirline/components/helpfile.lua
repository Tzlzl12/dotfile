return {
	condition = function()
		return vim.bo.filetype == "help"
	end,
	provider = function()
		print("into help")
		local filename = vim.api.nvim_buf_get_name(0)
		return vim.fn.fnamemodify(filename, ":t")
	end,
	hl = "Directory",
}
