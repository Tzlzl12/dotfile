return {
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    specs = {
      { "lewis6991/gitsigns.nvim", opts = { trouble = true } },
    },
    config = function(_, opts)
      -- dofile(vim.g.base46_cache .. "trouble")
      require("trouble").setup(opts)
    end,
    keys = {
      { "<leader>qx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Diagnostics " },
      { "<leader>qX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Trouble Symbols" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "Trouble LSP Tools" },
      { "<leader>qL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble Location List " },
      { "<leader>qQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble Quickfix List " },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Trouble Previous Trouble/Quickfix",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Trouble Next Trouble/Quickfix",
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Jump Todo-Comment Next" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Jump Todo-Comment Previous" },
      { "<leader>qt", "<cmd>Trouble todo toggle<cr>", desc = "Trouble Todo" },
      { "<leader>qT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Trouble Todo/Fix/Fixme" },
    },
  },
}
