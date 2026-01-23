vim.api.nvim_create_user_command("CreateDap", function()
  require "utils.create_dap"()
end, {})

vim.api.nvim_create_user_command("AddProject", function()
  require("utils.projects").write_projects_to_history()
end, {})

vim.api.nvim_create_user_command("ProjectLspConfig", function()
  require("utils.lspconfig").apply_base_lsp_config()
end, {})
