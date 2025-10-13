return {
  {
    "jay-babu/project.nvim",
    enabled = false,
    main = "project_nvim",
    -- event = "VeryLazy",
    opts = {
      manual_mode = true,
      patterns = {},
    },
    -- stylua: ignore
    keys = function()
      if not  vim.g.nvchad_use_telescope then
        return {}
      end
      return {
        {"<leader>fp",function() require("telescope").extensions.projects.projects {} end, desc = "telescope find project", },
      }
    end,
    ---
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local history = require "project_nvim.utils.history"
      history.delete_project = function(project)
        for k, v in pairs(history.recent_projects) do
          if v == project.value then
            history.recent_projects[k] = nil
            return
          end
        end
      end

      -- require("project_nvim").setup(opts)
      -- require("telescope").load_extension "projects"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    enabled = vim.g.nvchad_use_telescope,
    dependencies = { "jay-babu/project.nvim" },
    opts = function()
      require("telescope").load_extension "projects"
    end,
  },
}
