local M = {}

M.processing = false
M.spinner_index = 1

local spinner_symbols = {
  " ⠋",
  " ⠙",
  " ⠹",
  " ⠸",
  " ⠼",
  " ⠴",
  " ⠦",
  " ⠧",
  " ⠇",
  " ⠏",
}

local spinner_symbols_len = 10

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    group = group,
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        self.processing = true
        vim.g.nvchad_codecompanion_process = true
      elseif request.match == "CodeCompanionRequestFinished" then
        self.processing = false
        vim.defer_fn(function()
          vim.g.nvchad_codecompanion_process = false
        end, 5000)
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function M:update_status()
  if self.processing then
    vim.defer_fn(function()
      vim.cmd.redrawstatus()
      self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
    end, 10)
    return spinner_symbols[self.spinner_index] .. " Wait"
  else
    return " "
  end
end

return M
