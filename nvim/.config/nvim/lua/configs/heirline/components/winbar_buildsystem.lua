--   󰡨  

local get_root = require("utils").get_root_dir

local once = 0
local M = {}
local function has_file(file_name)
  if vim.fn.filereadable(get_root() .. file_name) == 1 then
    return true
  else
    return false
  end
end

local Build = function(fn)
  return {
    condition = function()
      local ok, _ = pcall(require, "overseer")
      return ok
    end,
    provider = "  ",
    on_click = {
      callback = function()
        fn()
      end,
      name = "build",
    },
  }
end

local CMakeBuild = {
  condition = function()
    return  has_file "/CMakeLists.txt"
  end,
  Build(function()
    vim.cmd "CMakeBuild"
  end),
}
local DefaultBuild = {
  provider = "  ",
  on_click = {
    callback = function()
      vim.cmd "OverseerRun"
    end,
    name = "build",
  },
}

-- return M
return {
  fallthrough = false,
  CMakeBuild,
  DefaultBuild,
}
