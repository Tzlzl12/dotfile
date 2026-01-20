local constants = require "overseer.constants"
local overseer = require "overseer"
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_pyproject_file(opts)
  return vim.fs.find("pyproject.toml", {
    upward = true,
    type = "file",
    path = opts.dir,
  })[1]
end

---@param cwd string
---@param cb fun(error: nil|string, project_root: nil|string)
local function get_project_root(cwd, cb)
  -- uv 没有类似 cargo metadata 的命令
  -- 直接使用 pyproject.toml 所在目录
  cb(nil, cwd)
end

local commands = {
  {
    name = "run current file",
    args = { "run" },
    tags = { TAG.RUN },
    needs_file = true,
  },
  {
    name = "sync",
    args = { "sync" },
    tags = { TAG.BUILD },
  },
  {
    name = "lock",
    args = { "lock" },
  },
  {
    name = "venv",
    args = { "venv" },
  },
  {
    name = "build",
    args = { "build" },
    tags = { TAG.BUILD },
  },
  {
    name = "publish",
    args = { "publish" },
  },
}

return {
  cache_key = function(opts)
    return get_pyproject_file(opts)
  end,

  generator = function(opts, cb)
    if vim.fn.executable "uv" == 0 then
      return 'Command "uv" not found'
    end

    local pyproject_file = get_pyproject_file(opts)
    if not pyproject_file then
      return "No pyproject.toml file found"
    end

    local project_dir = vim.fs.dirname(pyproject_file)
    local ret = {}

    get_project_root(project_dir, function(err, project_root)
      if err then
        return cb(err)
      end

      local roots = {
        {
          postfix = "",
          cwd = project_dir,
        },
      }

      for _, root in ipairs(roots) do
        for _, command in ipairs(commands) do
          table.insert(ret, {
            name = "uv " .. command.name,
            tags = command.tags,

            builder = function()
              local cmd = { "uv" }
              vim.list_extend(cmd, command.args)

              if command.needs_file then
                local file = vim.fn.expand "%:p"
                if file ~= "" then
                  table.insert(cmd, file)
                end
              end

              return {
                cmd = cmd,
                cwd = root.cwd,
                default_component_params = {
                  errorformat = [[%*\sFile "%f"\, line %l\, %m,]]
                    .. [[%E  File "%f"\, line %l,]]
                    .. [[%Z%p^,]]
                    .. [[%+G%.%#Error%.%#,]]
                    .. [[%+GTraceback%.%#,]]
                    .. [[%C    %.%#,]]
                    .. [[%-G%.%#]],
                  relative_file_root = root.relative_file_root,
                },
              }
            end,
          })
        end
      end

      cb(ret)
    end)
  end,
}
