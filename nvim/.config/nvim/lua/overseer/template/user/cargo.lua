local constants = require "overseer.constants"
local json = require "overseer.json"
local log = require "overseer.log"
local TAG = constants.TAG

local usb_attached = false

local function get_cargo_file(opts)
  return vim.fs.find("Cargo.toml", { upward = true, type = "file", path = opts.dir })[1]
end

local function parse_chip_name(cargo_dir)
  local file_path = cargo_dir .. "/Embed.toml"
  if vim.fn.filereadable(file_path) == 0 then
    return nil
  end
  local content = vim.fn.readfile(file_path)
  local in_section = false
  for _, line in ipairs(content) do
    line = vim.trim(line)
    if line:match "^%[default%.general%]$" then
      in_section = true
    elseif line:match "^%[" then
      in_section = false
    elseif in_section then
      local chip = line:match "^chip%s*=%s*[\"']([^\"']+)[\"']"
      if chip then
        return chip
      end
    end
  end
  return nil
end

local function is_in_subdir(file_path, subdir)
  if not file_path or file_path == "" then
    return false
  end
  local normalized = file_path:gsub("\\", "/")
  return normalized:match("/" .. subdir .. "/") ~= nil
end

return {
  name = "user.cargo",
  cache_key = function(opts)
    return get_cargo_file(opts)
  end,
  condition = {
    callback = function(opts)
      if vim.fn.executable "cargo" == 0 then
        return false, "cargo not found"
      end
      return get_cargo_file(opts) ~= nil
    end,
  },
  generator = function(opts, cb)
    local current_buf_path = vim.api.nvim_buf_get_name(0)
    local current_file_name = vim.fn.expand "%:t:r"
    local cargo_file = get_cargo_file(opts)

    if not cargo_file then
      return cb {}
    end

    local cargo_dir = vim.fs.dirname(cargo_file)

    vim.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" }, { cwd = cargo_dir }, function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          cb {}
        end)
        return
      end

      local ok, data = pcall(json.decode, res.stdout)
      local workspace_root = (ok and data) and data.workspace_root or nil

      -- 1. 精简后的通用命令列表
      local commands = {
        { args = { "build" }, tags = { TAG.BUILD } },
        { args = { "check" }, name_override = "cargo check" },
        { args = { "test" }, tags = { TAG.TEST }, name_override = "cargo test" },
        { args = { "clean" }, tags = { TAG.CLEAN }, name_override = "cargo clean" },
      }

      local is_embedded = vim.fn.filereadable(cargo_dir .. "/memory.x") == 1

      -- 2. 动态识别 Example / Bin (优先)
      local is_in_examples = is_in_subdir(current_buf_path, "examples")
      local is_in_bins = is_in_subdir(current_buf_path, "src/bin")

      if is_in_examples then
        table.insert(commands, 1, {
          args = { "run", "--example", current_file_name },
          name_override = string.format("cargo run --example %s", current_file_name),
          tags = { TAG.RUN },
          priority = 40,
        })
      elseif is_in_bins then
        table.insert(commands, 1, {
          args = { "run", "--bin", current_file_name },
          name_override = string.format("cargo run --bin %s", current_file_name),
          tags = { TAG.RUN },
          priority = 40,
        })
      end

      -- 3. 嵌入式特有逻辑
      if is_embedded then
        if not usb_attached then
          vim.system({ "usbipd.exe", "list" }, {}, function(usb_res)
            local busid = usb_res.stdout and usb_res.stdout:match "(%d+%.%d+)%s+STLink"
            if busid then
              vim.system { "usbipd.exe", "attach", "--wsl", "--busid", busid }
              usb_attached = true
            end
          end)
        end
        local chip = parse_chip_name(cargo_dir)
        if chip then
          if not is_in_examples and not is_in_bins then
            table.insert(commands, 1, {
              args = { "flash", "--chip", chip, "--release" },
              tags = { TAG.RUN },
              name_override = "cargo flash --chip " .. chip .. " --release",
            })
          end
        end
      else
        if not is_in_examples and not is_in_bins then
          table.insert(commands, 1, {
            args = { "run", "--release" },
            tags = { TAG.RUN },
          })
        end
      end

      -- 4. 构造任务返回 (Overseer 2.0 格式)
      local ret = {}
      local roots = { { postfix = "", cwd = cargo_dir } }
      if workspace_root and workspace_root ~= cargo_dir then
        table.insert(roots, { postfix = " (workspace)", cwd = workspace_root, relative_file_root = workspace_root })
      end

      for _, root in ipairs(roots) do
        for _, cmd in ipairs(commands) do
          local task_name = cmd.name_override or string.format("cargo %s%s", table.concat(cmd.args, " "), root.postfix)
          local task_priority = cmd.priority or 55

          table.insert(ret, {
            name = task_name,
            tags = cmd.tags,
            priority = task_priority,
            params = {},
            builder = function()
              return {
                cmd = { "cargo" },
                args = cmd.args,
                cwd = root.cwd,
                default_component_params = {
                  errorformat = [[%Eerror: %\%%(aborting %\|could not compile%\)%\@!%m,]]
                    .. [[%Eerror[E%n]: %m,]]
                    .. [[%Inote: %m,]]
                    .. [[%Wwarning: %\%%(%.%# warning%\)%\@!%m,]]
                    .. [[%C %#--> %f:%l:%c,]]
                    .. [[%E  left:%m,%C right:%m %f:%l:%c,%Z,]]
                    .. [[%.%#panicked at \'%m\'\, %f:%l:%c]],
                  relative_file_root = root.relative_file_root,
                },
              }
            end,
          })
        end
      end

      vim.schedule(function()
        cb(ret)
      end)
    end)
  end,
}
