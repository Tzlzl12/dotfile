-- require "nvchad.mappings"

require "keymaps.delete"
require "keymaps.telescope"
require "keymaps.terminal"
-- require "keymaps.term"
-- require "keymaps.ui"
require "keymaps.jump"

local map = vim.keymap.set

map("n", ";", ":", { desc = "General CMD enter command mode" })
map("n", "<C-h>", "<C-w>h", { desc = "General switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "General switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "General switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "General switch window up" })

map("n", "<leader>tt", function()
  vim.system({ "usbipd.exe", "list" }, { text = true }, function(res)
    local result = string.sub(res.stdout, 1, -2)
    vim.notify(result, vim.log.levels.WARN)
  end)
end)
map("n", "<esc>", function()
  require("noice").cmd "dismiss"
  if vim.o.hlsearch then
    vim.cmd.nohlsearch()
  end
end, { desc = "General Dismiss" })
-- map("n", "<esc>", function()
--   vim.cmd.nohlsearch()
--   vim.cmd.echo() -- 可选：清除命令行提示
-- end, { noremap = true, silent = true })
-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "General Save File" })
map("n", "<a-down>", "<cmd>m .+1<cr>==", { desc = "General Move Down" })
map("n", "<a-up>", "<cmd>m .-2<cr>==", { desc = "General Move Up" })
map("v", "<a-down>", ":m '>+1<cr>gv=gv", { desc = "General Move Down" })
map("v", "<a-up>", ":m '<-2<cr>gv=gv", { desc = "General Move Up" })

----
map("v", "<tab>", ">gv", { desc = "General Indent line" })
map("v", "<s-tab>", "<gv", { desc = "General Unindent line" })

-- comment
map("n", "<c-/>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-/>", "gc", { remap = true, desc = "General Toggle comment block" })
map("n", "<c-_>", "gcc", { remap = true, desc = "General Toggle comment line" })
map("v", "<c-_>", "gc", { remap = true, desc = "General Toggle comment block" })

map("n", "<A-Left>", "<C-o>")
map("n", "<A-Right>", "<C-o>")
-- map("n", "<down>", "gj")
-- map("n", "<up>", "gk")

map("n", "<c-n>", function()
  local dir = require("utils").get_root_dir()
  require("neo-tree.command").execute {
    toggle = true,
    dir = dir,
  }
end, { desc = " General Toggle Explorer" })

map("n", "cmg", "CMakegenerate<CR>", { desc = "General CMake Generate" })
map("n", "cmb", ":CMakeBuild", { desc = "General CMake Build" })
map("n", "cmr", ":CMakeRun", { desc = "General CMake Run" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "General buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "General buffer goto prev" })
map("n", "<leader>x", require("nvchad.tabufline").close_buffer, { desc = "General Buffer Close" })
map("n", "<leader>bx", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "General Buffer Close All" })
map("n", "<leader>tr", function()
  require("utils.fanyi").fanyi()
end, { desc = "General Translate(en to ch)" })
map("n", "<leader>ti", function()
  require("utils.fanyi").fanyi_ch_to_en()
end, { desc = "General Translate(ch to en)" })
map("n", "rw", function()
  require "utils.replace"()
end, { desc = "General Replace Word" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
