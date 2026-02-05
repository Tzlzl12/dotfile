local M = {}
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end
M.is_available = function(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

M.get_icon = function(icon_name)
  return require("configs.icons").icons[icon_name]
end

--- return lsp.root_dir , then workspace global variable, and fallback to `vim.uv.cwd()`
M.workspace = function()
  return vim.tbl_map(function(client)
    return client.config.root_dir
  end, vim.lsp.get_clients { bufnr = 0 })[1] or vim.g.workspace or vim.uv.cwd()
end

M.is_git_repo = function()
  local Path = require "plenary.path"
  local git_path = Path:new(vim.loop.cwd()):joinpath ".git"
  return git_path:exists()
end
M.get_plugin = function(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end
M.plugin_opts = function(plugin)
  local spec = M.get_plugin(plugin)
  return spec and require("lazy.core.plugin").values(spec, "opts") or {}
end

M.find_git_root = function()
  local current_dir = require("utils").get_root_dir()
  if current_dir == "" then
    return nil
  end

  -- 规范化路径（处理`../`等相对路径）
  current_dir = vim.fn.fnamemodify(current_dir, ":p")

  -- 从当前目录开始向上查找
  while current_dir ~= "/" do
    local git_dir = current_dir .. "/.git"

    -- 检查.git是否存在（可以是文件或目录）
    if vim.fn.isdirectory(git_dir) == 1 or vim.fn.filereadable(git_dir) == 1 then
      return current_dir
    end

    -- 向上级目录移动
    local parent = vim.fn.fnamemodify(current_dir, ":h")
    if parent == current_dir then -- 到达根目录
      break
    end
    current_dir = parent
  end

  return nil
end

M.insert = function(target, source)
  for key, value in pairs(source) do
    target[key] = value
  end
end
return M
