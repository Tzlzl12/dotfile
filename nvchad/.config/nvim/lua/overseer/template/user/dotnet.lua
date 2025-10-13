local constants = require "overseer.constants"
local json = require "overseer.json"
local log = require "overseer.log"
local overseer = require "overseer"
local TAG = constants.TAG

---@type overseer.TemplateFileDefinition
local tmpl = {
  priority = 60,
  params = {
    args = { type = "list", delimiter = " " },
    cwd = { optional = true },
    project_file = { optional = true },
    relative_file_root = {
      desc = "Relative filepaths will be joined to this root (instead of task cwd)",
      optional = true,
    },
  },
  builder = function(params)
    local args = vim.deepcopy(params.args)
    if params.project_file then
      table.insert(args, params.project_file)
    end

    return {
      cmd = { "dotnet" },
      args = args,
      cwd = params.cwd,
      default_component_params = {
        errorformat = [[%f(%l\,%c): %trror %m,]]
          .. [[%f(%l\,%c): %tarning %m,]]
          .. [[%f: %trror %m,]]
          .. [[%f: %tarning %m,]]
          .. [[%tarning %m,]]
          .. [[%trror %m,]]
          .. [[%f(%l\,%c): %m,]]
          .. [[%f:%l:%c: %m]],
        relative_file_root = params.relative_file_root,
      },
    }
  end,
}

---@param opts overseer.SearchParams
---@return nil|string
local function get_dotnet_file(opts)
  -- 先查找 .sln 文件
  local solution = vim.fs.find(function(name)
    return name:match "%.sln$"
  end, { upward = true, type = "file", path = opts.dir })[1]

  if solution then
    return solution
  end

  -- 再查找 .csproj 文件
  local project = vim.fs.find(function(name)
    return name:match "%.csproj$" or name:match "%.fsproj$" or name:match "%.vbproj$"
  end, { upward = true, type = "file", path = opts.dir })[1]

  return project
end

---@param cwd string
---@param solution_path nil|string
---@param cb fun(error: nil|string, projects: nil|table)
local function get_projects(cwd, solution_path, cb)
  if not solution_path then
    -- 如果没有解决方案文件，就只返回当前目录
    cb(nil, { cwd })
    return
  end

  -- 找出解决方案包含的所有项目
  local jid = vim.fn.jobstart({ "dotnet", "sln", solution_path, "list" }, {
    cwd = cwd,
    stdout_buffered = true,
    on_stdout = function(j, output)
      local projects = {}
      local proj_pattern = "^%s*(.+%.%w+proj)%s*$"

      for _, line in ipairs(output) do
        local proj = line:match(proj_pattern)
        if proj then
          -- 转换为绝对路径
          local project_path = vim.fn.fnamemodify(vim.fs.joinpath(vim.fs.dirname(solution_path), proj), ":p")
          table.insert(projects, vim.fs.dirname(project_path))
        end
      end

      if #projects > 0 then
        cb(nil, projects)
      else
        cb(nil, { cwd }) -- 如果没有找到项目，就使用当前目录
      end
    end,
    on_stderr = function(j, data)
      if #data > 1 or (#data == 1 and data[1] ~= "") then
        cb("Error listing projects: " .. table.concat(data, "\n"))
      end
    end,
    on_exit = function(j, code)
      if code ~= 0 then
        cb("dotnet sln list exited with code " .. code)
      end
    end,
  })

  if jid == 0 then
    cb "Passed invalid arguments to 'dotnet sln list'"
  elseif jid == -1 then
    cb "'dotnet' is not executable"
  end
end

return {
  cache_key = function(opts)
    return get_dotnet_file(opts)
  end,
  condition = {
    callback = function(opts)
      if vim.fn.executable "dotnet" == 0 then
        return false, 'Command "dotnet" not found'
      end
      if not get_dotnet_file(opts) then
        return false, "No .sln or .csproj file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local dotnet_file = assert(get_dotnet_file(opts))
    local dotnet_dir = vim.fs.dirname(dotnet_file)
    local solution_path = nil
    local project_path = nil

    if dotnet_file:match "%.sln$" then
      solution_path = dotnet_file
    else
      project_path = dotnet_file
    end

    local ret = {}

    get_projects(dotnet_dir, solution_path, function(err, projects)
      if err then
        log:error("Error fetching dotnet projects: %s", err)
        cb(ret)
        return
      end

      local commands = {
        { args = { "build" }, tags = { TAG.BUILD } },
        { args = { "run" }, tags = { TAG.RUN } },
        { args = { "test" }, tags = { TAG.TEST } },
        { args = { "clean" }, tags = { TAG.CLEAN } },
        { args = { "restore" } },
        { args = { "publish" } },
        { args = { "pack" } },
        { args = { "watch", "run" }, tags = { TAG.RUN } },
        { args = { "watch", "test" }, tags = { TAG.TEST } },
        { args = { "build", "--configuration", "Release" }, tags = { TAG.BUILD } },
        { args = { "build", "--configuration", "Debug" }, tags = { TAG.BUILD } },
      }

      -- 为解决方案文件添加命令
      if solution_path then
        local roots = {
          {
            postfix = " (solution)",
            cwd = dotnet_dir,
            project_file = solution_path,
            priority = 55,
          },
        }

        for _, root in ipairs(roots) do
          for _, command in ipairs(commands) do
            table.insert(
              ret,
              overseer.wrap_template(tmpl, {
                name = string.format("dotnet %s%s", table.concat(command.args, " "), root.postfix),
                tags = command.tags,
                priority = root.priority,
              }, {
                args = command.args,
                cwd = root.cwd,
                project_file = root.project_file and vim.fn.fnamemodify(root.project_file, ":."),
                relative_file_root = root.relative_file_root,
              })
            )
          end

          table.insert(
            ret,
            overseer.wrap_template(tmpl, { name = "dotnet" .. root.postfix }, {
              cwd = root.cwd,
              project_file = root.project_file and vim.fn.fnamemodify(root.project_file, ":."),
              relative_file_root = root.relative_file_root,
            })
          )
        end
      end

      -- 为项目文件添加命令
      if project_path or #projects > 0 then
        -- 处理单个项目
        if project_path then
          local project_name = vim.fn.fnamemodify(project_path, ":t")
          local root = {
            postfix = " (" .. project_name .. ")",
            cwd = vim.fs.dirname(project_path),
            project_file = project_path,
            priority = 50,
          }

          for _, command in ipairs(commands) do
            table.insert(
              ret,
              overseer.wrap_template(tmpl, {
                name = string.format("dotnet %s%s", table.concat(command.args, " "), root.postfix),
                tags = command.tags,
                priority = root.priority,
              }, {
                args = command.args,
                cwd = root.cwd,
                project_file = vim.fn.fnamemodify(root.project_file, ":."),
                relative_file_root = root.relative_file_root,
              })
            )
          end

          table.insert(
            ret,
            overseer.wrap_template(tmpl, { name = "dotnet" .. root.postfix }, {
              cwd = root.cwd,
              project_file = vim.fn.fnamemodify(root.project_file, ":."),
              relative_file_root = root.relative_file_root,
            })
          )
        else
          -- 处理解决方案中的多个项目
          for _, project_dir in ipairs(projects) do
            -- 查找项目目录中的项目文件
            local proj_files = vim.fn.glob(project_dir .. "/*.{csproj,fsproj,vbproj}", true, true)
            if #proj_files > 0 then
              local proj_file = proj_files[1]
              local project_name = vim.fn.fnamemodify(proj_file, ":t:r")

              local root = {
                postfix = " (" .. project_name .. ")",
                cwd = project_dir,
                project_file = proj_file,
                priority = 45,
              }

              for _, command in ipairs(commands) do
                table.insert(
                  ret,
                  overseer.wrap_template(tmpl, {
                    name = string.format("dotnet %s%s", table.concat(command.args, " "), root.postfix),
                    tags = command.tags,
                    priority = root.priority,
                  }, {
                    args = command.args,
                    cwd = root.cwd,
                    project_file = vim.fn.fnamemodify(root.project_file, ":."),
                    relative_file_root = root.relative_file_root,
                  })
                )
              end

              table.insert(
                ret,
                overseer.wrap_template(tmpl, { name = "dotnet" .. root.postfix }, {
                  cwd = root.cwd,
                  project_file = vim.fn.fnamemodify(root.project_file, ":."),
                  relative_file_root = root.relative_file_root,
                })
              )
            end
          end
        end
      end

      cb(ret)
    end)
  end,
}
