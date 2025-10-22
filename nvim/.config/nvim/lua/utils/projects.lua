local M = {}
local function dir_exists(dir)
	local stat = vim.uv.fs_stat(dir)
	if stat ~= nil and stat.type == "directory" then
		return true
	end
	return false
end
function M.get_recent_projects()
	local projects_file = vim.fn.stdpath("data") .. "/projects.txt"

	if vim.fn.filereadable(projects_file) == 0 then
		return {}
	end

	local lines = vim.fn.readfile(projects_file)
	local valid_projects = {}

	for _, dir in ipairs(lines) do
		if dir ~= "" and dir_exists(dir) then
			table.insert(valid_projects, dir)
		end
	end

	return valid_projects
end

function M.write_projects_to_history()
	local projects_file = vim.fn.stdpath("data") .. "/projects.txt"
	vim.fn.mkdir(vim.fn.fnamemodify(projects_file, ":h"), "p")

	local project_path = vim.uv.cwd()
	local current_projects = {}
	if vim.fn.filereadable(projects_file) == 1 then
		current_projects = vim.fn.readfile(projects_file)
	end

	-- 检查是否已存在
	local exists = false
	for _, line in ipairs(current_projects) do
		if line == project_path then
			exists = true
			break
		end
	end

	if not exists then
		table.insert(current_projects, project_path)
		vim.fn.writefile(current_projects, projects_file)
	end
end

M.recent = false
M.preset = "ivy"
-- M.projects = require("project_nvim.utils.history").get_recent_projects()
M.projects = M.get_recent_projects()
M.win = {
	preview = { minimal = true },
	input = {
		keys = {
			-- every action will always first change the cwd of the current tabpage to the project
			["<c-d>"] = {
				function(picker)
					local item = picker:get_current()
					-- vim.print(item)
					vim.print(picker)
				end,
				mode = { "n", "i" },
			},
			["<c-t>"] = {
				function(picker)
					vim.cmd("tabnew")
					Snacks.notify("New tab opened")
					picker:close()
					Snacks.picker.projects()
				end,
				mode = { "n", "i" },
			},
		},
	},
}
return M
