local map = vim.keymap.set
local del = vim.keymap.del

local fn = require "keymap.fn"

map("n", "<leader>ta", function()
  local color = require "onedarkpro.helpers"
  local colors = color.get_preloaded_colors()
  vim.print(colors)
end)
-- map("n", "<c-n>", function()
--   local dir = require("utils").get_root_dir()
--   require("neo-tree.command").execute {
--     toggle = true,
--     dir = dir,
--   }
-- end, { desc = "General Toggle Explorer" })

map("n", ";", ":", { desc = "General CMD enter command mode" })
map("n", "<C-h>", "<C-w>h", { desc = "General switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "General switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "General switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "General switch window up" })

-- buffer
map("n", "<tab>", function()
  fn.next()
end, { desc = "buffer goto next" })
map("n", "<S-tab>", function()
  fn.prev()
end, { desc = "buffer goto prev" })
map("n", "<leader>x", function()
  fn.del_curbuf()
end, { desc = "General Close Buffer" })
map("n", "<leader>bx", function()
  fn.del_othbuf()
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

map("n", "<a-up>", "<cmd>m .-2<cr>==", { desc = "General Move Up" })
map("n", "<a-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "General Move Down" })
map("v", "<a-down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<a-up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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
