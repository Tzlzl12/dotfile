local map = vim.keymap.set

local terminal = require("toggleterm.terminal")

local prefix = "<leader>T"
local id = 2

local exec = function(cmd)
	local term_width = math.floor(vim.o.columns * 0.35)
	term_width = term_width > 35 and term_width or 35
	local term = terminal.Terminal:new({
		direction = "float",
		close_on_exit = true,
		hidden = false,
		float_opts = {
			border = "double",
		},
	})
	if not term:is_open() then
		term:toggle(term_width)
	end
	term:send(cmd, false) -- 发送命令，但不重复显示
end
local term_toggle = function()
	local all_terms = terminal.get_all() -- 获取所有终端

	-- 遍历所有终端，检查是否有已经打开的
	for _, t in pairs(all_terms) do
		if t:is_open() then
			t:toggle() -- 关闭已打开的终端
			return
		end
	end
	local current_dir = require("utils").get_root_dir()

	local term = terminal.get(2)
	if term == nil then -- 没有创建了一个终端
		term = require("toggleterm.terminal").Terminal:new({
			direction = "float",
			dir = current_dir,
			id = id,
			float_opts = {
				border = "double",
			},
		})
	end
	if id == 2 then
		id = id + 1
	end
	term:toggle()

	vim.schedule(function()
		if term:is_open() then
			vim.cmd("startinsert!")
		end
	end)
end
local term_toggle_t = function()
	local all_terms = terminal.get_all() -- 获取所有终端
	local has_open_term = false

	-- 遍历所有终端，检查是否有已经打开的
	for _, t in pairs(all_terms) do
		if t:is_open() then
			t:toggle() -- 关闭已打开的终端
			return
		end
	end

	-- 如果没有终端是打开状态，就打开 ID = 2 的终端
	if not has_open_term then
		local expect_id = 2
		local existing_term = terminal.get(expect_id)

		if existing_term then
			existing_term:toggle()
		end
	end
end

map("n", "<C-Space>", function()
	term_toggle()
end, { desc = "General Toggle Terminal" })
map("n", "<c-`>", function()
	term_toggle()
end, { desc = "General Toggle Terminal" })

map(
	"t",
	"<c-space>",
	function()
		term_toggle_t()
	end,
	-- ":ToggleTerm<cr>",
	{ desc = "General Toggle Terminal" }
)
map(
	"t",
	"<c-`>",
	function()
		term_toggle_t()
	end,
	-- ":ToggleTerm<cr>",
	{ desc = "General Toggle Terminal" }
)

map("n", "<leader>rc", function()
	local ret = require("keymaps.compiler").get_compiler()
	if ret == nil then
		print("This file type is not support")
		return
	end
	local cmd = require("keymaps.compiler").compile(ret[1], ret[2])
	exec(cmd)
end, { desc = "General Task Run" })

local Terminal = terminal.Terminal

map("n", "<leader>fm", ":Telescope toggleterm_manager<cr>", { desc = "Telescope Toggle Term" })
-- 创建浮动终端（Node.js）
map("n", prefix .. "n", function()
	local node_term = Terminal:new({
		cmd = "node",
		direction = "float",
		hidden = true,
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
	})
	node_term:toggle()
end, { desc = "Terminal Node" })

-- 创建浮动终端（Python）
map("n", prefix .. "p", function()
	local python_term = Terminal:new({
		cmd = "python",
		direction = "float",
		hidden = true,
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
	})
	python_term:toggle()
end, { desc = "Terminal Python" })
map("n", "<leader>gg", function()
	-- if not require("utils").is_git_repo() then
	--   vim.notify "This is not a git repo"
	--   return
	-- else
	local git = ""
	if vim.fn.executable("gitui") == 1 then
		git = "gitui"
	elseif vim.fn.executable("lazygit") == 1 then
		git = "lazygit"
	else
		print("not found any git tui, such as `lazygit` or `gitui`")
		return
	end
	local node_term = Terminal:new({
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
	-- end
end, { desc = "Terminal Git" })
-- 创建浮动终端（Bottom 监控工具）
map("n", prefix .. "t", function()
	local btm_term = Terminal:new({
		cmd = "btop",
		direction = "float",
		hidden = true,
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
	})
	btm_term:toggle()
end, { desc = "Terminal Btm" })

-- 创建 **水平** 终端（相当于 `split`）
map({ "n", "t" }, prefix .. "h", function()
	local hor_term = Terminal:new({
		direction = "horizontal",
		hidden = true,
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
	})
	hor_term:toggle()
end, { desc = "Terminal Horizontal" })

-- 创建 **垂直** 终端（相当于 `vsplit`）
map({ "n", "t" }, prefix .. "v", function()
	local ver_term = Terminal:new({
		direction = "vertical",
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
	})
	ver_term:toggle()
end, { desc = "Terminal Vertical" })

-- **创建一个新的水平终端**
map("n", prefix .. "a", function()
	id = id + 1
	local new_term = Terminal:new({
		direction = "horizontal",
		close_on_exit = true,
		float_opts = {
			border = "double",
		},
		id = id,
	})
	new_term:toggle()
end, { desc = "Terminal New" })
-- map("n", prefix .. "m", "<cmd>Telescope terms<CR>", { desc = "Terminal Manager" })
