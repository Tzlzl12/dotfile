vim.api.nvim_create_user_command("CreateDap", function()
  -- 获取当前工作目录
  local cwd = vim.fn.getcwd()
  local dap_file_path = cwd .. "/.dap.lua"

  -- 检查文件是否存在
  local file_exists = vim.fn.filereadable(dap_file_path) == 1

  if file_exists then
    print ".dap.lua existed"
    return
  end

  -- 创建模板内容，使用返回值形式
  local template = [[
  --  local file = vim.fn.expand "%:p"
  --  local file_without_ext = vim.fn.fnamemodify(file, ":t:r")
  --  local parent_dir = vim.fn.fnamemodify(file, ":h:h")


return {
  -- 这里使用点占位符，用户需要手动填入语言名
  ["<lang>"] = {
    {
      name = "Debug",
      type = "<adapters>",
      request = "launch",
      -- program = utils.input_exec_path(),
      console = "integratedTerminal",
      program = function()
        return vim.ui.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      terminal = "integrated",
    }
  }
}
]]

  -- 写入文件
  local file = io.open(dap_file_path, "w")
  if file then
    file:write(template)
    file:close()
  else
    print "Can`t create .dap.lua file"
  end
end, {})
vim.api.nvim_create_user_command("AddProjects", function()
  require("extensions.projects").write_projects_to_history()
end, {})
