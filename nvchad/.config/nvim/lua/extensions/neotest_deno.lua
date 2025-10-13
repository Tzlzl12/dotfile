-- ~/.config/nvim/lua/my-deno-adapter.lua
-- 一个简化的、用于学习目的的 neotest-deno 适配器

local M = {}

M.name = "MyDenoAdapter"

---
--- 检查文件是否为 Deno 测试文件
---@param file_path string
---@return boolean
function M.is_test_file(file_path)
  return file_path:match "_test.ts$"
    or file_path:match "%.test.ts$"
    or file_path:match "_test.js$"
    or file_path:match "%.test.js$"
end

---
--- 从文件中发现所有测试的位置
---@param path string
---@return neotest.Position[] | nil
function M.discover_positions(path)
  local command = { "deno", "test", "--json", "--no-run", path }
  local output = vim.fn.systemlist(command)

  if vim.v.shell_error ~= 0 then
    vim.notify("MyDenoAdapter: Discovery failed for " .. path, vim.log.levels.ERROR)
    vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  local positions = {}
  for _, line in ipairs(output) do
    local ok, data = pcall(vim.fn.json_decode, line)
    if ok and data.type == "testPlan" and data.modules then
      for _, module in ipairs(data.modules) do
        -- 确保我们只处理当前文件的测试
        if module.origin == path then
          for _, test in ipairs(module.tests) do
            table.insert(positions, {
              type = "test",
              path = path,
              name = test.name,
              range = {
                test.location.line - 1, -- Neotest 行号从 0 开始
                test.location.col - 1, -- Neotest 列号从 0 开始
                test.location.line - 1,
                (test.location.col - 1) + #test.name,
              },
            })
          end
        end
      end
    end
  end

  return positions
end

---
--- 构建运行测试的规范
---@param pos neotest.Position
---@return neotest.RunSpec
function M.build_spec(pos, _)
  -- 基础命令
  local command = { "deno", "test", "--json" }

  -- 为单个测试或命名空间构建过滤器参数
  if pos.type == "test" or pos.type == "namespace" then
    -- Deno 的 filter 接受 "测试名" 或 "命名空间 / 测试名" 的形式
    -- pos.name 已经包含了完整的层级结构
    table.insert(command, "--filter=" .. pos.name)
  end

  -- 添加要测试的文件路径
  table.insert(command, pos.path)

  return {
    runner = "json_stream",
    command = command,
    id_field = "name", -- 在 Deno 的 JSON 输出中，用 `name` 字段来匹配测试
    outcome_map = {
      ["ok"] = "passed",
      ["failed"] = "failed",
      ["ignored"] = "skipped",
      ["pending"] = "skipped",
    },
    adapter_id = M.name,
  }
end

return M
