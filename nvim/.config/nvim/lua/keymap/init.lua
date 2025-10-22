local map = vim.keymap.set
local del = vim.keymap.del

map("n", "<c-n>", function()
	local dir = require("utils").get_root_dir()
	require("neo-tree.command").execute({
		toggle = true,
		dir = dir,
	})
end, { desc = " General Toggle Explorer" })

map("n", ";", ":", { desc = "General CMD enter command mode" })
map("n", "<C-h>", "<C-w>h", { desc = "General switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "General switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "General switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "General switch window up" })

map("n", "q", "", {})
map("n", "<esc>", function()
	require("noice").cmd("dismiss")
	if vim.o.hlsearch then
		vim.cmd.nohlsearch()
	end
end, { desc = "General Dismiss" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "General Save File" })
map("n", "<a-down>", "<cmd>m .+1<cr>==", { desc = "General Move Down" })
map("n", "<a-up>", "<cmd>m .-2<cr>==", { desc = "General Move Up" })
map("v", "<a-down>", ":m '>+1<cr>gv=gv", { desc = "General Move Down" })
map("v", "<a-up>", ":m '<-2<cr>gv=gv", { desc = "General Move Up" })

----
map("v", "<tab>", ">gv", { desc = "General Indent line" })
map("v", "<s-tab>", "<gv", { desc = "General Unindent line" })

map("n", "<c-/>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-/>", "gc", { remap = true, desc = "General Toggle comment block" })
map("n", "<c-_>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-_>", "gc", { remap = true, desc = "General Toggle comment block" })

map("n", "<A-Left>", "<C-o>")
map("n", "<A-Right>", "<C-o>")

-- custon function
map("n", "<leader>tr", function()
	require("utils.fanyi").fanyi()
end, { desc = "General Translate(en to ch)" })
map("n", "<leader>ti", function()
	require("utils.fanyi").fanyi_ch_to_en()
end, { desc = "General Translate(ch to en)" })
map("n", "rw", function()
	require("utils.replace")()
end, { desc = "General Replace Word" })

vim.schedule(function()
	require("keymap.jump")
	require("keymap.term")
	require("keymap.ui")
end)
