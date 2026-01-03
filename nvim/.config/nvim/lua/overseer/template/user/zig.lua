local constants = require "overseer.constants"
local TAG = constants.TAG

---@param opts overseer.SearchParams
---@return nil|string
local function get_zig_file(opts)
  return vim.fs.find("build.zig.zon", { upward = true, type = "file", path = opts.dir })[1]
end

return {
  -- 在 Provider 模式下，cache_key 是合法的
  cache_key = function(opts)
    return get_zig_file(opts)
  end,
  -- 核心逻辑：generator 负责返回一组模板
  generator = function(opts, cb)
    local zig_file = get_zig_file(opts)
    if not zig_file then
      return cb {}
    end

    if vim.fn.executable "zig" == 0 then
      return cb {}
    end

    local zig_dir = vim.fs.dirname(zig_file)
    local ret = {}

    -- 1. 基础构建命令
    local base_commands = {
      { args = { "build" }, tags = { TAG.BUILD } },
      { args = { "build", "run" }, tags = { TAG.RUN } },
      { args = { "build", "test" }, tags = { TAG.TEST } },
      { args = { "test" }, tags = { TAG.TEST } },
      { args = { "build", "--summary", "all" }, tags = { TAG.BUILD } },
      { args = { "build", "-Doptimize=ReleaseFast" }, tags = { TAG.BUILD } },
    }

    for _, command in ipairs(base_commands) do
      table.insert(ret, {
        name = string.format("zig %s", table.concat(command.args, " ")),
        tags = command.tags,
        builder = function()
          return {
            cmd = vim.list_extend({ "zig" }, command.args),
            cwd = zig_dir,
            default_component_params = {
              errorformat = [[%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m,%-G%.%#]],
            },
          }
        end,
      })
    end

    -- 2. 扫描 examples 目录
    local examples_dir = zig_dir .. "/examples"
    if vim.fn.isdirectory(examples_dir) == 1 then
      local handle = vim.loop.fs_scandir(examples_dir)
      if handle then
        while true do
          local name, type = vim.loop.fs_scandir_next(handle)
          if not name then
            break
          end

          if type == "file" and name:match "%.zig$" then
            local example_name = name:gsub("%.zig$", "")
            local step_name = "run-example-" .. example_name

            table.insert(ret, {
              name = "zig example: " .. example_name,
              group = "examples",
              tags = { TAG.RUN },
              builder = function()
                return {
                  cmd = { "zig", "build", step_name },
                  cwd = zig_dir,
                  default_component_params = {
                    errorformat = [[%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m,%-G%.%#]],
                  },
                }
              end,
            })
          end
        end
      end
    end

    cb(ret)
  end,
}
