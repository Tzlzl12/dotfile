---@diagnostic disable: undefined-global
local CodeCompanionStatus = {
  static = {
    has_chat = false, -- 是否有活跃的 chat buffer
    processing = false,
    spinner_index = 1,
    spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  },

  -- 初始化：监听 chat 创建/关闭 + 请求开始/结束
  init = function(self)
    local group = vim.api.nvim_create_augroup("HeirlineCodeCompanion", { clear = true })

    -- chat 创建时：标记有活跃 chat
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionChatCreated",
      group = group,
      callback = function()
        self.has_chat = true
        vim.cmd "redrawstatus"
      end,
    })

    -- chat 关闭时：标记无活跃 chat
    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionChatClosed",
      group = group,
      callback = function()
        self.has_chat = false
        self.processing = false -- 防止残留 spinner
        vim.cmd "redrawstatus"
      end,
    })

    -- 请求开始/结束
    vim.api.nvim_create_autocmd("User", {
      pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
      group = group,
      callback = function(opts)
        if opts.match == "CodeCompanionRequestStarted" then
          self.processing = true
        elseif opts.match == "CodeCompanionRequestFinished" then
          self.processing = false
        end
        vim.cmd "redrawstatus"
      end,
    })
  end,

  -- 动画更新：只有在处理中且有 chat 时才刷新 spinner
  update = {
    callback = function(self)
      if self.processing and self.has_chat then
        vim.defer_fn(function()
          self.spinner_index = (self.spinner_index % #self.spinner_symbols) + 1
          vim.cmd "redrawstatus"
        end, 80)
      end
      return self.has_chat -- 只有有 chat 时才持续更新组件
    end,
    interval = 80, -- 刷新频率（ms）
  },

  -- 整体条件：只有有活跃 chat 时才显示组件
  condition = function(self)
    return self.has_chat
  end,

  -- 处理中：模型名 + spinner
  {
    condition = function(self)
      return self.processing
    end,
    hl = { fg = "yellow", bold = true },
    provider = function(self)
      local model = coecompanion_chat_metadata
          and codecompanion_chat_metadata.adapter
          and codecompanion_chat_metadata.adapter.model
        or "Unknown"
      return model .. " " .. self.spinner_symbols[self.spinner_index]
    end,
  },

  -- 空闲（有 chat 但不处理）：模型名 + ✔
  {
    hl = { fg = "green" },
    provider = function()
      local model = codecompanion_chat_metadata
          and codecompanion_chat_metadata.adapter
          and codecompanion_chat_metadata.adapter.model
        or "Unknown"
      return model .. " "
    end,
  },
}

return CodeCompanionStatus
