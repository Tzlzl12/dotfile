local constants = require "overseer.constants"
local json = require "overseer.json"
local overseer = require "overseer"
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_zig_file(opts)
  return vim.fs.find("build.zig.zon", { upward = true, type = "file", path = opts.dir })[1]
end

---@param cwd string
---@param cb fun(error: nil|string, project_root: nil|string)
local function get_project_root(cwd, cb)
  -- Zig 项目根目录就是 build.zig.zon 所在目录
  cb(nil, cwd)
end

local commands = {
  { args = { "build" }, tags = { TAG.BUILD } },
  { args = { "build", "run" }, tags = { TAG.RUN } },
  { args = { "build", "test" }, tags = { TAG.TEST } },
  { args = { "test" }, tags = { TAG.TEST } },
  { args = { "build", "install" } },
  { args = { "build", "--summary", "all" }, tags = { TAG.BUILD } },
  { args = { "build", "-Doptimize=ReleaseFast" }, tags = { TAG.BUILD } },
  { args = { "build", "-Doptimize=ReleaseSafe" }, tags = { TAG.BUILD } },
  { args = { "build", "-Doptimize=ReleaseSmall" }, tags = { TAG.BUILD } },
  -- { args = { "fmt" } },
  -- { args = { "fmt", "--check" } },
  { args = { "translate-c" } },
  { args = { "cc" } },
  { args = { "c++" } },
  -- { args = { "fetch" } },
}

return {
  cache_key = function(opts)
    return get_zig_file(opts)
  end,
  generator = function(opts, cb)
    if vim.fn.executable "zig" == 0 then
      return 'Command "zig" not found'
    end
    local zig_file = get_zig_file(opts)
    if not zig_file then
      return "No build.zig.zon file found"
    end
    local zig_dir = vim.fs.dirname(zig_file)
    local ret = {}

    get_project_root(zig_dir, function(err, project_root)
      if err then
        return cb(err)
      end

      local roots = { {
        postfix = "",
        cwd = zig_dir,
      } }

      for _, root in ipairs(roots) do
        for _, command in ipairs(commands) do
          table.insert(ret, {
            name = string.format("zig %s%s", table.concat(command.args, " "), root.postfix),
            tags = command.tags,
            builder = function()
              return {
                cmd = vim.list_extend({ "zig" }, command.args),
                cwd = root.cwd,
                default_component_params = {
                  errorformat = [[%f:%l:%c: %trror: %m,]]
                    .. [[%f:%l:%c: %tarning: %m,]]
                    .. [[%f:%l:%c: %tote: %m,]]
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
