local lib = require "neotest.lib"

local NeotestZig = {}

NeotestZig.name = "neotest-zig-custom"

-- 识别根目录
NeotestZig.root = lib.files.match_root_pattern("build.zig", ".git")

-- 识别测试文件
function NeotestZig.is_test_file(file_path)
  return vim.endswith(file_path, ".zig")
end

-- 发现测试位置
function NeotestZig.discover_positions(path)
  local query_str = [[
    (test_declaration
      (string
        (string_content) @test.name
      )
    ) @test.definition
  ]]

  -- 使用同步方式读取文件内容，规避异步协程陷阱
  local content = ""
  local ok_read, lines = pcall(vim.fn.readfile, path)
  if ok_read then
    content = table.concat(lines, "\n")
  end

  -- 强制指定语言为 zig 进行解析
  return lib.treesitter.parse_positions_from_string(path, content, query_str, {
    nested_tests = false,
    language = "zig",
  })
end

-- 构建执行命令
function NeotestZig.build_spec(args)
  local position = args.tree:data()
  local command = { "zig", "test", position.path }

  -- 如果运行具体测试项，则增加 --test-filter
  if position.type == "test" and position.name then
    table.insert(command, "--test-filter")
    table.insert(command, position.name)
  end

  return {
    command = command,
    context = {
      pos_id = position.id,
      path = position.path,
    },
  }
end

-- 解析测试结果
function NeotestZig.results(spec, result, tree)
  local output = (result.output or ""):gsub("\27%[[0-9;]*m", "") -- 去除 ANSI 颜色
  local results = {}

  for _, node in tree:iter_nodes() do
    local data = node:data()
    if data.type == "test" then
      -- 针对 Zig 0.15.2 输出格式进行正则匹配: test "name"... ok
      local escaped_name = data.name:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1")
      local pattern = 'test "' .. escaped_name .. '"%.%.%.%s+(%w+)'
      local status_match = output:match(pattern)

      local status = "passed"
      if status_match == "FAIL" or (result.code ~= 0 and data.path == spec.context.path) then
        status = "failed"
      elseif status_match == "SKIP" then
        status = "skipped"
      end

      results[data.id] = {
        status = status,
        errors = status == "failed" and { { message = "Zig test failed. Check output for details." } } or {},
      }
    end
  end
  return results
end

return NeotestZig
