local icons = require("configs.icons").icons

local Dap = {
  condition = function()
    local ok, _ = pcall(require, "dap")
    return ok
  end,
  provider = function()
    return icons.Debugger
  end,
  hl = "red",
  on_click = {
    callback = function()
      local dap_choice = { "use configure(deafault)", "use configure(project)" }
      vim.ui.select(dap_choice, { prompt = "Dap Configure" }, function(choice)
        if choice == "use configure(project)" then
          local root_dir = require("utils").get_root_dir()
          local dap_file = root_dir .. "/.dap.lua"
          if not vim.fn.filereadable(dap_file) then -- 文件不存在存在
            vim.cmd "CreateDap"
            print "create dap default config"
            return
          end
        end
        require("dapui").toggle {}
      end)
    end,
    name = "dap",
  },
}

return Dap
