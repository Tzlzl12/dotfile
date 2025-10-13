local prefix = "<leader>r"
return {
  "kawre/leetcode.nvim",
  -- build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  cmd = "Leet",
  keys = {
    {
      prefix .. "n",
      mode = "n",
      ":Leet run<cr>",
      desc = "LeetCode Run",
    },
    {
      prefix .. "p",
      mode = "n",
      function()
        local difficulty = { "easy", "medium", "hard" }
        vim.ui.select(difficulty, { prompt = "Select Difficulty" }, function(choice)
          if choice then
            -- print(choice)
            vim.cmd("Leet list status=todo difficulty=" .. choice)
          end
        end)
      end,
      desc = "LeetCode Problem",
    },
    {
      prefix .. "s",
      mode = "n",
      ":Leet submit<cr>",
      desc = "LeetCode Submit",
    },
    {
      prefix .. "l",
      mode = "n",
      ":Leet<cr>",
      desc = "LeetCode Menu",
    },
  },
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- configuration goes here
    cn = {
      enabled = true,
    },
    image_support = true,
  },
}
