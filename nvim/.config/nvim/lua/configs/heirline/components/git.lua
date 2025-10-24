local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local icons = require("configs.icons").icons
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim

local git_color = "bright_bg"
return {
	condition = function()
		return require("utils").is_git_repo()
	end,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,
	on_click = {
		callback = function(self, minwid, nclicks, button)
			vim.defer_fn(function()
				local git = ""
				local terminal = require("toggleterm.terminal").Terminal
				if vim.fn.executable("gitui") == 1 then
					git = "gitui"
				elseif vim.fn.executable("lazygit") == 1 then
					git = "lazygit"
				else
					print("not found any git tui, such as `lazygit` or `gitui`")
					return
				end
				local node_term = terminal:new({
					cmd = git,
					dir = "git_dir",
					direction = "float",
					hidden = true,
					close_on_exit = true,
					float_opts = {
						border = "double",
					},
				})
				node_term:toggle()
			end, 100)
		end,
		name = "heirline_git",
		update = false,
	},
	hl = { fg = "orange" },
	{
		provider = function(self)
			print("into git")
			return icons.GitBranch .. self.status_dict.head
		end,
		hl = { bold = true, fg = "green", bg = git_color },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "(",
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and (icons.GitAdd .. count)
		end,
		hl = { fg = utils.get_highlight("NeoTreeGitAdded").fg, bg = git_color },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and (icons.GitDelete .. count)
		end,
		hl = { fg = utils.get_highlight("NeoTreeGitDeleted").fg, bg = git_color },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and (icons.GitChange .. count)
		end,
		hl = { fg = utils.get_highlight("NeoTreeGitRenamed").fg, bg = git_color },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = ")",
	},
}
