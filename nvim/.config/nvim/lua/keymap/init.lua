local map = vim.keymap.set
local del = vim.keymap.del

map("n", "<leader>ta", function()
  require("utils.workspace").open(vim.env.HOME)
end)
-- map("n", "<c-n>", function()
--   local dir = require("utils").get_root_dir()
--   require("neo-tree.command").execute {
--     toggle = true,
--     dir = dir,
--   }
-- end, { desc = "General Toggle Explorer" })

map("n", "<up>", "gk", { desc = "General Move line up" })
map("n", "<down>", "gj", { desc = "General Move line down" })
map("n", ";", ":", { desc = "General CMD enter command mode" })
map("n", "<C-h>", "<C-w>h", { desc = "General switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "General switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "General switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "General switch window up" })

-- buffer
map("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "General Buffer Prev" })
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "General Buffer Next" })
map("n", "<leader>x", function()
  Snacks.bufdelete()
end, { desc = "General Close Buffer" })
map("n", "<leader>bx", function()
  Snacks.bufdelete.other()
end, { desc = "General Close other Buffer" })

---
map("n", "q", "", {})
map("n", "<esc>", function()
  require("noice").cmd "dismiss"
  if vim.o.hlsearch then
    vim.cmd.nohlsearch()
  end
end, { desc = "General Dismiss" })

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "General Save File" })

-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Up" })

-- Visual 模式 (移动选中的行块)
-- map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
-- map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })
----
map("v", "<tab>", ">gv", { desc = "General Indent line" })
map("v", "<s-tab>", "<gv", { desc = "General Unindent line" })

map("n", "<c-/>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-/>", "gc", { remap = true, desc = "General Toggle comment block" })
map("n", "<c-_>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-_>", "gc", { remap = true, desc = "General Toggle comment block" })

map("n", "cmg", ":CMakegenerate<CR>", { desc = "General CMake Generate" })
map("n", "cmb", ":CMakeBuild<cr>", { desc = "General CMake Build" })
map("n", "cmr", ":CMakeRun<cr>", { desc = "General CMake Run" })

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
  require "utils.replace"()
end, { desc = "General Replace Word" })

vim.schedule(function()
  require "keymap.jump"
  require "keymap.term"
end)
