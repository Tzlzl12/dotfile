local del = vim.keymap.del

vim.api.nvim_set_keymap("n", "q", "<NOP>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "q", "<NOP>", { noremap = true, silent = true })
-- del("n", "<leader>b")
-- del("n", "<leader>e")
-- del("n", "<leader>h")
-- del("n", "<leader>n")
-- del("n", "<leader>v")
-- del({ "n", "v" }, "<leader>/")
--
-- del("n", "<leader>ma")
-- del("n", "<leader>th")
-- del("n", "<leader>pt")
-- del("n", "<leader>cm")
