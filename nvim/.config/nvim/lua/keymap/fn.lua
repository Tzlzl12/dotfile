local M = {}

M.save = function()
  local buffer_is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
  if buffer_is_modified then
    vim.cmd "write"
  else
    print "Buffer not modified. No writing is done."
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end
-- 删除当前 buffer（智能删除，保持窗口布局）
function M.del_curbuf()
  local buf = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[buf].buftype

  -- 如果是特殊 buffer（terminal, quickfix 等），直接关闭窗口
  if buftype ~= "" then
    vim.cmd "close"
    return
  end

  -- 获取所有 buffer 列表
  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  -- 如果只剩一个 buffer，创建新的空 buffer
  if #buffers <= 1 then
    vim.cmd "enew"
    vim.cmd("bdelete " .. buf)
    return
  end

  -- 找到下一个要切换的 buffer
  local next_buf = nil
  for i, b in ipairs(buffers) do
    if b == buf then
      -- 优先切换到下一个，如果没有则切换到上一个
      next_buf = buffers[i + 1] or buffers[i - 1]
      break
    end
  end

  -- 切换到下一个 buffer 并删除当前 buffer
  if next_buf then
    vim.api.nvim_set_current_buf(next_buf)
    vim.cmd("bdelete " .. buf)
  end
end

-- 切换到下一个 buffer
function M.next()
  local current = vim.api.nvim_get_current_buf()

  -- 获取所有可见的 buffer
  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  -- 如果只有一个或没有 buffer，不做操作
  if #buffers <= 1 then
    return
  end

  -- 找到当前 buffer 的位置
  for i, buf in ipairs(buffers) do
    if buf == current then
      -- 切换到下一个，如果是最后一个则回到第一个（循环）
      local next_buf = buffers[i + 1] or buffers[1]
      vim.api.nvim_set_current_buf(next_buf)
      return
    end
  end
end

-- 切换到上一个 buffer
function M.prev()
  local current = vim.api.nvim_get_current_buf()

  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())

  if #buffers <= 1 then
    return
  end

  for i, buf in ipairs(buffers) do
    if buf == current then
      -- 切换到上一个，如果是第一个则回到最后一个（循环）
      local prev_buf = buffers[i - 1] or buffers[#buffers]
      vim.api.nvim_set_current_buf(prev_buf)
      return
    end
  end
end

-- 关闭其他所有 buffer（只保留当前）
function M.del_othbuf()
  local current = vim.api.nvim_get_current_buf()

  local buffers = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= current
  end, vim.api.nvim_list_bufs())

  for _, buf in ipairs(buffers) do
    vim.cmd("bdelete " .. buf)
  end
end

return M
