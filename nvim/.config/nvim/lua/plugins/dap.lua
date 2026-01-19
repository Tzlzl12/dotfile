-- 1. 定义高亮颜色 (放在外部以保持 config 简洁)
local dap_highlights = {
  DapUIPlayPause = { fg = "#98be65" },
  DapUIRestart = { fg = "#51afef" },
  DapUIStepInto = { fg = "#ecbe7b" },
  DapUIStepOver = { fg = "#c678dd" },
  DapUIStepOut = { fg = "#da8548" },
  DapUIModifiedValue = { fg = "#ecbe7b", bold = true },
  DapUIBreakpointsPath = { fg = "#5B6268" },
}

-- 用于追踪外部进程 (如 OpenOCD)
local openocd_handle = nil

return {
  -----------------------------------------------------------------------------
  -- Nvim-Dap: 核心引擎
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    -- stylua: ignore
    keys = function()
      return {
        { "<leader>d", "", desc = "Debug", mode = {"n", "v"} },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Dap Breakpoint condition: ") end, desc = "Dap Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Dap Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Dap Run/Continue" },
        {"<leader>dm", "", desc = "Dap Move"},
        { "<leader>dmC", function() require("dap").run_to_cursor() end, desc = "Dap Run to Cursor" },
        { "<leader>dmg", function() require("dap").goto_() end, desc = "Dap Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Dap Step Into" },
        { "<leader>dmj", function() require("dap").down() end, desc = "Dap Down" },
        { "<leader>dmk", function() require("dap").up() end, desc = "Dap Up" },
        { "<leader>dml", function() require("dap").run_last() end, desc = "Dap Run Last" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Dap Step Out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "Dap Step Over" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Dap Toggle REPL" },
        { "<leader>du", function() require("dapui").toggle() end, desc = "Dap Terminate" },
      }
    end,
    config = function()
      local dap = require "dap"

      -- A. 设置不同语言的 Adapter (根据你的逻辑)
      local file_type = vim.bo.filetype
      if file_type == "c" or file_type == "cpp" then
        require("dap.codelldb").setup()
      elseif file_type == "python" then
        require("dap.debugpy").setup()
      elseif file_type == "rust" then
        require("dap.codelldb-rs").setup()
      end

      -- B. 加载项目本地 .dap.lua 配置 (修复了覆盖漏洞)
      local dap_config_path = vim.fn.getcwd() .. "/.dap.lua"
      if vim.fn.filereadable(dap_config_path) == 1 then
        local status, local_conf = pcall(dofile, dap_config_path)
        if status and type(local_conf) == "table" then
          for lang, configs in pairs(local_conf) do
            dap.configurations[lang] = dap.configurations[lang] or {}
            if vim.isarray(configs) then
              for _, c in ipairs(configs) do
                table.insert(dap.configurations[lang], c)
              end
            else
              table.insert(dap.configurations[lang], configs)
            end
          end
        end
      end

      -- C. 高亮与图标设置
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- 假设你的 icons 路径正确，若报错请检查 require 路径
      local status_icons, icons_mod = pcall(require, "configs.icons")
      if status_icons then
        for name, sign in pairs(icons_mod.icons.dap) do
          sign = type(sign) == "table" and sign or { sign }
          vim.fn.sign_define("Dap" .. name, {
            text = sign[1],
            texthl = sign[2] or "DiagnosticInfo",
            linehl = sign[3],
            numhl = sign[3],
          })
        end
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Dap UI: 界面与自动化
  -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {
      icons = { expanded = " ", collapsed = " ", current_frame = " " },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.6 },
            { id = "stacks", size = 0.4 },
          },
          size = 0.25,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          position = "bottom",
          size = 0.25,
        },
      },
      controls = { enabled = true, element = "repl" },
    },
    config = function(_, opts)
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup(opts)

      -- 应用自定义高亮
      for group, colors in pairs(dap_highlights) do
        vim.api.nvim_set_hl(0, group, colors)
      end

      -- 自动化：启动调试时打开 UI + 自动启动 OpenOCD (针对嵌入式)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- 检查是否存在特定文件判断是否为嵌入式项目
        if vim.fn.filereadable(vim.fn.getcwd() .. "/memory.x") then
          openocd_handle = vim.system({
            "openocd",
            "-f",
            "interface/stlink.cfg",
            "-f",
            "target/stm32f4x.cfg",
          }, { text = true })
        end
        dapui.open()
      end

      -- 自动化：调试结束时关闭 UI + 杀掉 OpenOCD 进程
      local function close_dap()
        if openocd_handle then
          openocd_handle:kill(15) -- 发送 SIGTERM
          openocd_handle = nil
        end
        dapui.close()
      end

      dap.listeners.before.event_terminated["dapui_config"] = close_dap
      dap.listeners.before.event_exited["dapui_config"] = close_dap
    end,
  },

  -----------------------------------------------------------------------------
  -- Mason Integration & Virtual Text
  -----------------------------------------------------------------------------
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = { "codelldb", "python" }, -- 在此处添加常用调试器
      handlers = {},
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      commented = true, -- 在代码行末显示变量值
    },
  },
}
