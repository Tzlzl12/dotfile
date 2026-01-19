local CodeCompanionStatus = {
  static = {
    processing = false,
    spinner_index = 1,
    spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  },
  init = function(self)
    -- 监听 CodeCompanion 状态
    local group = vim.api.nvim_create_augroup("HeirlineCodeCompanion", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionRequest*",
      group = group,
      callback = function(opts)
        if opts.match == "CodeCompanionRequestStarted" then
          self.processing = true
        elseif opts.match == "CodeCompanionRequestFinished" then
          self.processing = false
        end
        vim.cmd "redrawstatus" -- 强制触发 Heirline 更新
      end,
    })
  end,
  -- 更新触发条件：当正在处理时，每隔一段时间触发一次 update
  update = function(self)
    if self.processing then
      -- 这里的定时器可以让动画动起来
      vim.defer_fn(function()
        self.spinner_index = (self.spinner_index % #self.spinner_symbols) + 1
        vim.cmd "redrawstatus"
      end, 80) -- 80ms 刷新一次动画
    end
    return true
  end,
  {
    condition = function(self)
      return self.processing
    end,
    hl = { fg = "yellow", bold = true }, -- 正在处理时的颜色
    provider = function(self)
      return " " .. self.spinner_symbols[self.spinner_index] .. " Waiting"
    end,
  },
  {
    condition = function(self)
      return not self.processing
    end,
    hl = { fg = "green" }, -- 完成后的颜色
    provider = "   Success",
  },
}
return CodeCompanionStatus
