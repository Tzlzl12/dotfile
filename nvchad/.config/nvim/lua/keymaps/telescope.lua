if vim.g.nvchad_use_telescope then
  local map = vim.keymap.set

  -- map("c", "<tab>", require("telescope-cmdline-word.picker").find_word, { silent = true, noremap = true })
  map("n", "<leader>fa", function()
    require("telescope.builtin").find_files {
      prompt_title = "Config Files",
      cwd = vim.fn.stdpath "config",
      follow = true,
    }
  end, { desc = "telescope Find Nvim config files" })
  map(
    "n",
    "<leader>fF",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "telescope find Files" }
  )
  map("n", "<leader>fg", function()
    require("telescope.builtin").git_files()
  end, { desc = "telescope find Git Files" })

  map("n", "<leader>fk", function()
    require("telescope.builtin").keymaps()
  end, { desc = "telescope find keymaps" })
  map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })

  map("n", "<leader>fn", function()
    require("telescope").extensions.notify.notify()
  end, { desc = "telescope find Notifications" })
  -- map("n", "<leader>fp", function()
  --   require("telescope").extensions.projects.projects {}
  -- end, { desc = "telescope find project" })

  map("n", "<leader>ft", function()
    require("nvchad.themes").open()
  end, { desc = "telescope nvchad themes" })

  map("n", "<leader>fW", function()
    require("telescope.builtin").live_grep {
      additional_args = function(args)
        return vim.list_extend(args, { "--hidden", "--no-ignore" })
      end,
    }
  end, { desc = "telescope find Words " })
end
