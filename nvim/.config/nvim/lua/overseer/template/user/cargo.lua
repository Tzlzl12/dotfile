local constants = require "overseer.constants"
local json = require "overseer.json"
local TAG = constants.TAG

local usb_attached = false

------------------------------------------------------------
-- utils
------------------------------------------------------------
local function get_cargo_file(opts)
  return vim.fs.find("Cargo.toml", {
    upward = true,
    type = "file",
    path = opts.dir,
  })[1]
end

local function is_in_subdir(file_path, subdir)
  if not file_path or file_path == "" then
    return false
  end
  local normalized = file_path:gsub("\\", "/")
  return normalized:match("/" .. subdir .. "/") ~= nil
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

local function detect_workspace_member(buf_path, metadata)
  if not metadata or not metadata.packages then
    return nil
  end

  for _, pkg in ipairs(metadata.packages) do
    local root = pkg.manifest_path:gsub("/Cargo.toml$", "")
    if buf_path:find(root, 1, true) == 1 then
      return pkg.name
    end
  end

  return nil
end

------------------------------------------------------------
-- template
------------------------------------------------------------
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
    local cargo_file = get_cargo_file(opts)
    if not cargo_file then
      return cb {}
    end

    local cargo_dir = vim.fs.dirname(cargo_file)

    --------------------------------------------------------
    -- cargo metadata
    --------------------------------------------------------
    vim.system({ "cargo", "metadata", "--no-deps", "--format-version", "1" }, { cwd = cargo_dir }, function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          cb {}
        end)
        return
      end

      local ok, metadata = pcall(json.decode, res.stdout)
      local workspace_root = ok and metadata and metadata.workspace_root or nil

      ----------------------------------------------------
      -- command definitions (NO buffer state here)
      ----------------------------------------------------
      local commands = {
        -- run
        -- {
        --   kind = "run_file",
        --   mode = "debug",
        --   name_override = "cargo run (current file)",
        --   tags = { TAG.RUN },
        --   priority = 50,
        -- },
        { kind = "run", mode = "debug", args = { "run" }, tags = { TAG.RUN }, priority = 40 },
        -- { kind = "run", mode = "release", args = { "run", "--release" }, tags = { TAG.RUN }, priority = 41 },

        -- common
        { args = { "build" }, tags = { TAG.BUILD } },
        -- { args = { "check" }, name_override = "cargo check" },
        -- { args = { "test" }, tags = { TAG.TEST }, name_override = "cargo test" },
        -- { args = { "clean" }, tags = { TAG.CLEAN }, name_override = "cargo clean" },
      }

      ----------------------------------------------------
      -- embedded support
      ----------------------------------------------------
      local is_embedded = vim.fn.filereadable(cargo_dir .. "/memory.x") == 1
      local chip = is_embedded and parse_chip_name(cargo_dir) or nil

      if is_embedded and chip then
        table.insert(commands, 1, {
          kind = "flash",
          args = { "flash", "--chip", chip, "--release" },
          tags = { TAG.RUN },
          name_override = "cargo flash --chip " .. chip .. " --release",
          priority = 30,
        })

        if not usb_attached then
          vim.system({ "usbipd.exe", "list" }, {}, function(usb_res)
            local busid = usb_res.stdout and usb_res.stdout:match "(%d+%.%d+)%s+STLink"
            if busid then
              vim.system { "usbipd.exe", "attach", "--wsl", "--busid", busid }
              usb_attached = true
            end
          end)
        end
      end

      ----------------------------------------------------
      -- roots
      ----------------------------------------------------
      local roots = {
        { postfix = "", cwd = cargo_dir },
      }

      if workspace_root and workspace_root ~= cargo_dir then
        table.insert(roots, {
          postfix = " (workspace)",
          cwd = workspace_root,
          relative_file_root = workspace_root,
        })
      end

      ----------------------------------------------------
      -- build tasks
      ----------------------------------------------------
      local ret = {}

      for _, root in ipairs(roots) do
        for _, cmd in ipairs(commands) do
          local task_name = cmd.name_override or string.format("cargo %s%s", table.concat(cmd.args, " "), root.postfix)

          table.insert(ret, {
            name = task_name,
            tags = cmd.tags,
            priority = cmd.priority or 55,

            builder = function()
              ------------------------------------------------
              -- DYNAMIC buffer-sensitive logic (核心)
              ------------------------------------------------
              local buf = vim.api.nvim_get_current_buf()
              local buf_path = vim.api.nvim_buf_get_name(buf)
              local file_name = vim.fn.fnamemodify(buf_path, ":t:r")

              local args = vim.deepcopy(cmd.args)

              if (cmd.kind == "run" or cmd.kind == "run_file") and buf_path ~= "" then
                local member = detect_workspace_member(buf_path, metadata)

                if is_in_subdir(buf_path, "examples") then
                  args = { "run" }

                  if member then
                    table.insert(args, "-p")
                    table.insert(args, member)
                  end

                  table.insert(args, "--example")
                  table.insert(args, file_name)
                elseif is_in_subdir(buf_path, "src/bin") then
                  args = { "run" }

                  if member then
                    table.insert(args, "-p")
                    table.insert(args, member)
                  end

                  table.insert(args, "--bin")
                  table.insert(args, file_name)
                elseif cmd.kind == "run_file" then
                  -- 普通 src/main.rs 或单文件项目
                  args = { "run" }
                end

                -- if cmd.mode == "release" then
                --   table.insert(args, "--release")
                -- end
              end
              return {
                cmd = { "cargo" },
                args = args,
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
