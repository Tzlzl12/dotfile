local M = {}
local utils = require "utils" -- 你已定义 get_root_dir()

local function exists(path)
  return vim.fn.filereadable(path) == 1
end

local function detect_project_type(root)
  if exists(root .. "/Cargo.toml") then
    return "rust"
  end
  if exists(root .. "/pyproject.toml") then
    return "python"
  end
  if exists(root .. "/CMakeLists.txt") then
    return "cpp"
  end
  return nil
end

M.apply_base_lsp_config = function()
  local kind = detect_project_type(utils.workspace())
  if kind == "rust" then
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            target = "x86_64-unknown-linux-gnu",
          },
          check = {
            allTargets = false,
            target = "x86_64-unknown-linux-gnu",
          },
        },
      },
    })
    return "rust_analyzer"
  elseif kind == "python" then
    vim.lsp.config("ty", {
      settings = {},
    })
    return "pyright"
  elseif kind == "cpp" then
    vim.lsp.config("clangd", {
      cmd = { "clangd" },
    })
    return "clangd"
  end
end

return M
