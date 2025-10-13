local M = {}

M.compile = function(compiler, flags)
  local cmd = ""
  local file_name = vim.fn.expand "%:p"

  if flags == "c" then
    local file_without_ext = vim.fn.fnamemodify(vim.fn.expand "%:p", ":t:r")
    local parent_dir = vim.fn.fnamemodify(vim.fn.expand "%:p", ":p:h")
    local bin_dir = parent_dir .. "/bin/"

    -- 确保 bin 目录存在
    if vim.fn.isdirectory(bin_dir) == 0 then
      vim.fn.mkdir(bin_dir, "p")
    end

    local clangd_file = require("utils").get_root_dir() .. "/.clangd"
    local parsed = require "utils.yaml"(clangd_file)
    local extra_flags = ""
    for _, flag in ipairs(parsed.CompileFlags.Add) do
      extra_flags = extra_flags .. flag .. " "
    end
    cmd = table.concat({
      compiler,
      file_name,
      extra_flags,
      "-g -o",
      bin_dir .. file_without_ext,
      "&&",
      bin_dir .. file_without_ext,
    }, " ")
    -- cmd = compiler
    --   .. " "
    --   .. file_name
    --   .. " "
    --   .. "-g -o"
    --   .. " "
    --   .. parent_dir
    --   .. "/bin/"
    --   .. file_without_ext
    --   .. " && "
    --   .. parent_dir
    --   .. "/bin/"
    --   .. file_without_ext
  elseif flags == "py" then
    cmd = table.concat({
      compiler,
      file_name,
    }, " ")
  end

  return cmd

  -- local root_dir = require("plugins.utils.utils").get_root_dir()
end

M.get_compiler = function()
  local file_type = vim.bo.filetype
  -- print(parent_dir)
  local result = {}
  if file_type == "cpp" then
    if vim.fn.executable "clang++" == 1 then
      table.insert(result, "clang++")
      table.insert(result, "c")
      -- compiler = "clang++"
    else
      table.insert(result, "g++")
      table.insert(result, "c")
      -- compiler = "g++"
    end
  elseif file_type == "c" then
    if vim.fn.executable "clang" then
      table.insert(result, "clang")
      table.insert(result, "c")
    else
      table.insert(result, "gcc")
      table.insert(result, "c")
    end
  elseif file_type == "python" then
    table.insert(result, "python")
    table.insert(result, "py")
  else
    return nil
  end

  return result
end
return M

-- vim.keymap.set("n", "<leader>rc", function()
--   local file_type = vim.bo.filetype
--   local cmd = ""
--   -- print(parent_dir)
--   if file_type == "cpp" then
--     local compiler = ""
--     if vim.fn.executable "clang++" == 1 then
--       compiler = "clang++"
--     else
--       compiler = "g++"
--     end
--     cmd = compile(compiler, "c")
--   elseif file_type == "c" then
--     local compiler = ""
--     if vim.fn.executable "clang" then
--       compiler = "clang"
--     else
--       compiler = "gcc"
--     end
--     cmd = compile(compiler, "c")
--   elseif file_type == "python" then
--     local compiler = "python"
--     cmd = compile(compiler, "py")
--   end
--   print(cmd)
--
--   -- require("nvchad.term").runner { pos = "float", cmd = cmd, id = "floatTerm", clear_cmd = false }
--   -- vim.cmd ":q"
-- end, { desc = "Task Run" })
