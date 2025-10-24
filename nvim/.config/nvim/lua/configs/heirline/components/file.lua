local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local icons = require("configs.heirline.common").icons
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local file_color = "gray"
local M = {}
M.FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color, bg = file_color }
	end,
}

M.FileName = {
	init = function(self)
		self.lfilename = vim.fn.fnamemodify(self.filename, ":t")
		if self.lfilename == "" then
			self.lfilename = "[No Name]"
		end
		if not conditions.width_percent_below(#self.lfilename, 0.27) then
			self.lfilename = vim.fn.pathshorten(self.lfilename)
		end
	end,
	hl = function()
		if vim.bo.modified then
			return { fg = utils.get_highlight("Directory").fg, bg = file_color, bold = true, italic = true }
		end
		return { fg = utils.get_highlight("Directory").fg, bg = file_color }
	end,
	flexible = 2,
	{
		provider = function(self)
			return self.lfilename
		end,
	},
	{
		provider = function(self)
			return vim.fn.pathshorten(self.lfilename)
		end,
	},
}

M.FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " " .. icons.modified,
		hl = { fg = "green", bg = file_color },
		on_click = {
			callback = function(_, minwid)
				local buf = vim.api.nvim_win_get_buf(minwid)
				local bufname = vim.api.nvim_buf_get_name(buf)
				vim.cmd.write(bufname)
			end,
			minwid = function()
				return vim.api.nvim_get_current_win()
			end,
			name = "heirline_write_buf",
		},
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = icons.readonly,
		hl = { fg = "blue", bg = file_color },
	},
}

M.FileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	M.FileIcon,
	M.FileName,
	unpack(M.FileFlags),
}
M.FileNameBlock = utils.surround({ separators.rounded_left, separators.rounded_right }, file_color, M.FileNameBlock)

M.FileType = {
	provider = function()
		return string.upper(vim.bo.filetype)
	end,
	hl = "Type",
}

M.FileEncoding = {
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
		return enc ~= "utf-8" and enc:upper()
	end,
}

M.FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return fmt ~= "unix" and fmt:upper()
	end,
}

M.FileSize = {
	provider = function()
		-- stackoverflow, compute human readable file size
		local suffix = { "b", "k", "M", "G", "T", "P", "E" }
		local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
		fsize = (fsize < 0 and 0) or fsize
		if fsize <= 0 then
			return "0" .. suffix[1]
		end
		local i = math.floor((math.log(fsize) / math.log(1024)))
		return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i])
	end,
}

M.FileLastModified = {
	provider = function()
		local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
		return (ftime > 0) and os.date("%c", ftime)
	end,
}
return M
