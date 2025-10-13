local M = {}
local function dir_exists(dir)
  local stat = vim.uv.fs_stat(dir)
  if stat ~= nil and stat.type == "directory" then
    return true
  end
  return false
end
function M.get_recent_projects()
  local projects_file = vim.fn.stdpath "data" .. "/projects.txt"

  if vim.fn.filereadable(projects_file) == 0 then
    return {}
  end

  local lines = vim.fn.readfile(projects_file)
  local valid_projects = {}

  for _, dir in ipairs(lines) do
    if dir ~= "" and dir_exists(dir) then
      table.insert(valid_projects, dir)
    end
  end

  return valid_projects
end

function M.write_projects_to_history()
  local projects_file = vim.fn.stdpath "data" .. "/projects.txt"
  vim.fn.mkdir(vim.fn.fnamemodify(projects_file, ":h"), "p")

  local project_path = vim.uv.cwd()
  local current_projects = {}
  if vim.fn.filereadable(projects_file) == 1 then
    current_projects = vim.fn.readfile(projects_file)
  end

  -- 检查是否已存在
  local exists = false
  for _, line in ipairs(current_projects) do
    if line == project_path then
      exists = true
      break
    end
  end

  if not exists then
    table.insert(current_projects, project_path)
    vim.fn.writefile(current_projects, projects_file)
  end
end
-- function M.write_projects_to_history()
--   local projects_file = vim.fn.stdpath "data" .. "/projects.txt"
--
--   -- 确保目录存在
--   vim.fn.mkdir(vim.fn.fnamemodify(projects_file, ":h"), "p")
--
--   -- 合并所有项目，处理 nil 情况
--   local all_projects = {}
--
--   if M.recent_projects then
--     all_projects = vim.list_extend(all_projects, M.recent_projects)
--   end
--
--   if M.session_projects then
--     all_projects = vim.list_extend(all_projects, M.session_projects)
--   end
--
--   -- 去重
--   local unique_projects = {}
--   local seen = {}
--   for _, project in ipairs(all_projects) do
--     if not seen[project] and dir_exists(project) then
--       table.insert(unique_projects, project)
--       seen[project] = true
--     end
--   end
--
--   -- 写入文件
--   vim.fn.writefile(unique_projects, projects_file)
-- end
-- function M.get_recent_projects()
--   -- 直接读取 projects.txt 文件
--   local projects_file = vim.fn.stdpath "data" .. "/projects.txt"
--
--   -- 如果文件不存在，返回空表
--   if vim.fn.filereadable(projects_file) == 0 then
--     return {}
--   end
--
--   -- 读取文件内容
--   local lines = vim.fn.readfile(projects_file)
--
--   -- 过滤有效目录
--   local valid_projects = {}
--   for _, dir in ipairs(lines) do
--     if dir ~= "" and dir_exists(dir) then
--       table.insert(valid_projects, dir)
--     end
--   end
--
--   return valid_projects
-- end
M.recent = false
M.preset = "ivy"
-- M.projects = require("project_nvim.utils.history").get_recent_projects()
M.projects = M.get_recent_projects()
M.win = {
  preview = { minimal = true },
  input = {
    keys = {
      -- every action will always first change the cwd of the current tabpage to the project
      ["<c-d>"] = {
        function(picker)
          local item = picker:get_current()
          -- vim.print(item)
          vim.print(picker)
          -- print("Picker opts:", vim.inspect(picker.opts))
          -- print("Picker win:", vim.inspect(picker.win))
          -- print("Picker meta:", vim.inspect(picker.meta))
          -- local item = picker:current()
          -- if not item then
          --   vim.notify "No project selected"
          --   return
          -- end
          --
          -- local project_path = item.text or item.value or item
          -- print(project_path)

          -- -- 直接删除，无需确认
          -- if delete_project(project_path) then
          --   vim.notify("Project deleted: " .. project_path)
          --   -- 刷新picker
          --   picker:close()
          --   Snacks.picker.projects()
          -- end
        end,
        mode = { "n", "i" },
      },
      ["<c-t>"] = {
        function(picker)
          vim.cmd "tabnew"
          Snacks.notify "New tab opened"
          picker:close()
          Snacks.picker.projects()
        end,
        mode = { "n", "i" },
      },
    },
  },
}
return M
