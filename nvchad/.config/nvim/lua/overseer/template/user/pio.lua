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
    relative_file_root = {
      desc = "Relative filepaths will be joined to this root (instead of task cwd)",
      optional = true,
    },
  },
  builder = function(params)
    return {
      cmd = { "pio" },
      args = params.args,
      cwd = params.cwd,
      default_component_params = {
        errorformat = [[%Eerror: %m,]]
          .. [[%Eerror[%n]: %m,]]
          .. [[%Wwarning: %m,]]
          .. [[%Inote: %m,]]
          .. [[%C %#--> %f:%l:%c,]]
          .. [[%C%*\s%f:%l:%c:,]]
          .. [[%C%*\s%f:%l:,]]
          .. [[%Z%m]],
        relative_file_root = params.relative_file_root,
      },
    }
  end,
}

---@param opts overseer.SearchParams
---@return nil|string
local function get_platformio_file(opts)
  return vim.fs.find("platformio.ini", { upward = true, type = "file", path = opts.dir })[1]
end

---@param cwd string
---@param cb fun(error: nil|string, project_info: nil|table)
local function get_project_info(cwd, cb)
  local jid = vim.fn.jobstart({ "pio", "project", "data", "--json-output" }, {
    cwd = cwd,
    stdout_buffered = true,
    on_stdout = function(j, output)
      local ok, data = pcall(json.decode, table.concat(output, ""))
      if ok then
        cb(nil, data)
      else
        cb "Failed to parse PlatformIO project data"
      end
    end,
    on_stderr = function(j, output)
      if #output > 0 then
        cb(table.concat(output, "\n"))
      end
    end,
  })
  if jid == 0 then
    cb "Passed invalid arguments to 'pio project data'"
  elseif jid == -1 then
    cb "'pio' is not executable"
  end
end

return {
  cache_key = function(opts)
    return get_platformio_file(opts)
  end,
  condition = {
    callback = function(opts)
      if vim.fn.executable "pio" == 0 then
        return false, 'Command "pio" not found'
      end
      if not get_platformio_file(opts) then
        return false, "No platformio.ini file found"
      end
      return true
    end,
  },
  generator = function(opts, cb)
    local pio_dir = vim.fs.dirname(assert(get_platformio_file(opts)))
    local ret = {}

    get_project_info(pio_dir, function(err, project_info)
      if err then
        log:debug("Error fetching PlatformIO project info: %s", err)
        -- Continue without project info
      end

      local commands = {
        -- Build commands
        { args = { "run" }, tags = { TAG.BUILD }, desc = "Build project" },
        { args = { "run", "--target", "clean" }, tags = { TAG.CLEAN }, desc = "Clean build files" },
        { args = { "run", "--target", "cleanall" }, tags = { TAG.CLEAN }, desc = "Clean all build files" },

        -- Upload/Flash commands
        { args = { "run", "--target", "upload" }, tags = { TAG.BUILD }, desc = "Upload firmware" },
        -- { args = { "run", "--target", "uploadfs" }, tags = { TAG.DEPLOY }, desc = "Upload filesystem" },
        -- { args = { "run", "--target", "uploadfsota" }, tags = { TAG.DEPLOY }, desc = "Upload filesystem OTA" },

        -- Monitor commands
        { args = { "device", "monitor" }, tags = { TAG.RUN }, desc = "Serial monitor" },

        -- Test commands
        { args = { "test" }, tags = { TAG.TEST }, desc = "Run tests" },
        { args = { "test", "--verbose" }, tags = { TAG.TEST }, desc = "Run tests (verbose)" },

        -- Check commands
        { args = { "check" }, desc = "Static code analysis" },
        { args = { "check", "--verbose" }, desc = "Static code analysis (verbose)" },

        -- Library management
        { args = { "lib", "update" }, desc = "Update libraries" },
        { args = { "lib", "list" }, desc = "List libraries" },

        -- Platform management
        -- { args = { "platform", "update" }, desc = "Update platforms" },
        -- { args = { "platform", "list" }, desc = "List platforms" },

        -- Device management
        -- { args = { "device", "list" }, desc = "List devices" },

        -- Project commands
        -- { args = { "project", "init" }, desc = "Initialize project" },
        -- { args = { "project", "data" }, desc = "Show project data" },
      }

      -- Add environment-specific commands if we have project info
      local environments = {}
      if project_info and project_info.envs then
        for env_name, _ in pairs(project_info.envs) do
          table.insert(environments, env_name)
        end
      end

      local roots = {
        {
          postfix = "",
          cwd = pio_dir,
          priority = 55,
        },
      }

      for _, root in ipairs(roots) do
        -- Add general commands
        for _, command in ipairs(commands) do
          table.insert(
            ret,
            overseer.wrap_template(tmpl, {
              name = string.format("pio %s%s", table.concat(command.args, " "), root.postfix),
              tags = command.tags,
              priority = root.priority,
            }, { args = command.args, cwd = root.cwd, relative_file_root = root.relative_file_root })
          )
        end

        -- Add environment-specific commands
        for _, env in ipairs(environments) do
          local env_commands = {
            { args = { "run", "-e", env }, tags = { TAG.BUILD }, desc = "Build for " .. env },
            { args = { "run", "-e", env, "--target", "upload" }, tags = { TAG.DEPLOY }, desc = "Upload to " .. env },
            { args = { "run", "-e", env, "--target", "clean" }, tags = { TAG.CLEAN }, desc = "Clean " .. env },
            { args = { "test", "-e", env }, tags = { TAG.TEST }, desc = "Test " .. env },
            { args = { "check", "-e", env }, desc = "Check " .. env },
          }

          for _, command in ipairs(env_commands) do
            table.insert(
              ret,
              overseer.wrap_template(tmpl, {
                name = string.format("pio %s%s", table.concat(command.args, " "), root.postfix),
                tags = command.tags,
                priority = root.priority,
              }, { args = command.args, cwd = root.cwd, relative_file_root = root.relative_file_root })
            )
          end
        end

        -- Add generic pio command
        table.insert(
          ret,
          overseer.wrap_template(
            tmpl,
            { name = "pio" .. root.postfix },
            { cwd = root.cwd, relative_file_root = root.relative_file_root }
          )
        )
      end
      cb(ret)
    end)
  end,
}
