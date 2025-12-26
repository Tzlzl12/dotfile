local code = require "utils.code-process"

return {
  init = function()
    code:init()
  end,
  conditions = vim.g.codecompanion_process,
  provider = function()
    return code:update_status()
  end,
  update = {
    "User",
    pattern = "CodeCompanionRequest*",
    callback = vim.schedule_wrap(function()
      vim.cmd "redrawstatus"
    end),
  },
}
