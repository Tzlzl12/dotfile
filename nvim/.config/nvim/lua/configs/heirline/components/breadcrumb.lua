local M = {}

local ts_utils = require "nvim-treesitter.ts_utils"
local icons = require "mini.icons"

local cache = {
  buf = nil,
  line = nil,
  tick = nil,
  value = nil,
}

local MAX_SYMBOL = 4

-- treesitter node → LSP symbol
local allowed = {
  function_definition = "Function",
  function_item = "Function",
  method_definition = "Method",
  method_declaration = "Method",

  class_definition = "Class",
  class_declaration = "Class",

  struct_item = "Struct",
  struct_specifier = "Struct",

  enum_item = "Enum",
  enum_specifier = "Enum",
  enum_declaration = "Enum",

  impl_item = "Module",
  mod_item = "Module",

  namespace_definition = "Module",
}

-- 识别名称
local function get_identifier(node)
  for child in node:iter_children() do
    local t = child:type()

    if t == "identifier" or t == "type_identifier" or t == "field_identifier" then
      return vim.treesitter.get_node_text(child, 0)
    end
  end
end

-- 获取 symbol path
local function get_symbols()
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return {}
  end

  local result = {}

  while node do
    local t = node:type()

    if allowed[t] then
      local name = get_identifier(node)

      if name then
        table.insert(result, 1, {
          name = name,
          kind = allowed[t],
        })
      end
    end

    node = node:parent()
  end

  if #result > MAX_SYMBOL then
    result = { unpack(result, #result - MAX_SYMBOL + 1) }
  end

  return result
end

-- 只获取 当前目录 + 文件
local function get_file_part()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return {}
  end

  local dir = vim.fn.fnamemodify(file, ":h:t")
  local name = vim.fn.fnamemodify(file, ":t")

  return {
    {
      name = dir,
      kind = "Directory",
    },
    {
      name = name,
      kind = "File",
    },
  }
end

local function build()
  local parts = get_file_part()

  local symbols = get_symbols()

  for _, s in ipairs(symbols) do
    table.insert(parts, s)
  end

  return parts
end

function M.get()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local tick = vim.b.changedtick

  if cache.buf == buf and cache.line == line and cache.tick == tick then
    return cache.value
  end

  local val = build()

  cache.buf = buf
  cache.line = line
  cache.tick = tick
  cache.value = val

  return val
end

function M.render_symbols()
  local items = get_symbols()
  if #items == 0 then
    return ""
  end

  local parts = {}

  for i, item in ipairs(items) do
    local icon = icons.get("lsp", item.kind) or ""
    if icon ~= "" then
      icon = icon .. " "
    end

    parts[#parts + 1] = icon .. item.name

    if i ~= #items then
      parts[#parts + 1] = " > "
    end
  end

  return table.concat(parts)
end

function M.render_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return ""
  end

  local name = vim.fn.fnamemodify(file, ":t")

  return name
end

function M.render_folder()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return ""
  end

  local dir = vim.fn.fnamemodify(file, ":h:t")

  return dir
end

local function separator()
  return {
    provider = " > ",
    hl = "Comment",
  }
end

local Symbols = {
  provider = function()
    return M.render_symbols()
  end,
}

local File = {
  init = function(self)
    self.name = M.render_file()
  end,
  {
    provider = function(self)
      local ic, hl = icons.get("file", self.name)
      self.icon_hl = hl
      return ic and (ic .. " ") or ""
    end,
    hl = function(self)
      return self.icon_hl
    end,
  },
  {
    provider = function(self)
      return self.name
    end,
  },
  separator(),
}

local Folder = {
  init = function(self)
    self.name = M.render_folder()
  end,

  {
    provider = function(self)
      local ic, hl = icons.get("directory", self.name)
      self.icon_hl = hl
      return ic and (ic .. " ") or ""
    end,
    hl = function(self)
      return self.icon_hl
    end,
  },
  {
    provider = function(self)
      return self.name
    end,
  },
  separator(),
}

return {
  condition = function()
    return vim.bo.buftype == ""
  end,
  flexible = 3, -- 移到最外层，不要再套一层 {}
  { Folder, File, Symbols },
  { File, Symbols },
  { Symbols },
  update = { "CursorMoved", "BufEnter", "InsertLeave", "WinResized" },
  hl = { fg = "gray" },
}
