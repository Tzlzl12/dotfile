local icons = require("configs.icons").icons

local Dap = {
  {
    condition = function()
      local ok, _ = pcall(require, "dap")
      return ok
    end,
    provider = function()
      return icons.debug .. require("dap").status() .. " "
    end,
    hl = "Debug",
    on_click = {
      call_back = function() end,
    },
  },
}
return { fallthrough = false, Dap }
