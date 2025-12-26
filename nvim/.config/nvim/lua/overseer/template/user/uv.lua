local file = vim.fn.expand "%:p"

local constants = require "overseer.constants"
local json = require "overseer.json"
local overseer = require "overseer"
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_pyproject_file(opts)
  return vim.fs.find("pyproject.toml", { upward = true, type = "file", path = opts.dir })[1]
end

---@param cwd string
---@param cb fun(error: nil|string, project_root: nil|string)
local function get_project_root(cwd, cb)
  -- uv 没有像 cargo metadata 这样的命令，直接使用 pyproject.toml 所在目录
  cb(nil, cwd)
end

local commands = {
  { args = { "run", file }, tags = { TAG.RUN } },
  -- { args = { "run", "pytest" }, tags = { TAG.TEST } },
  { args = { "sync" }, tags = { TAG.BUILD } },
  { args = { "lock" } },
  -- { args = { "add" } },
  -- { args = { "remove" } },
  -- { args = { "tree" } },
  -- { args = { "pip", "compile" } },
  -- { args = { "pip", "sync" } },
  { args = { "venv" } },
  { args = { "build" }, tags = { TAG.BUILD } },
  { args = { "publish" } },
  -- { args = { "tool", "run", "ruff", "check" } },
  -- { args = { "tool", "run", "ruff", "format" } },
  -- { args = { "tool", "run", "mypy" } },
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

      local roots = { {
        postfix = "",
        cwd = project_dir,
      } }

      for _, root in ipairs(roots) do
        for _, command in ipairs(commands) do
          table.insert(ret, {
            name = string.format("uv %s%s", table.concat(command.args, " "), root.postfix),
            tags = command.tags,
            builder = function()
              return {
                cmd = vim.list_extend({ "uv" }, command.args),
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
