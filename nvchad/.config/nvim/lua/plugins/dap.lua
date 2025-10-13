return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle {}
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Dap Eval",
        mode = { "n", "v" },
      },
    },
    opts = {
      force_buffers = true,
      mappings = {
        -- Use a table to apply multiple mappings
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      icons = {
        expanded = " ",
        collapsed = " ",
        current_frame = " ",
      },
      layouts = {
        {
          elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
              id = "scopes",
              size = 0.6, -- Can be float or integer > 1
            },
            -- { id = "watches", size = 0.3 },
            { id = "stacks", size = 0.4 },
            -- { id = "breakpoints", size = 0.1 },
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
      controls = {
        enabled = true,
        -- Display controls in this session
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "󰆹",
          step_over = "󰆷",
          step_out = "󰆸",
          step_back = "",
          run_last = "↻",
          terminate = "󰝤",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      render = { indent = 1, max_value_lines = 85 },
    },
    config = function(_, opts)
      -- dofile(vim.g.base46_cache .. "dap")
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        if vim.fn.filereadable(vim.uv.cwd() .. "/memory.x") then
          vim.system(
            { "openocd", "-f", "interface/stlink.cfg", "-f", "target/stm32f4x.cfg" },
            { text = true },
            function(obj)
              print(obj.code)
            end
          )
        end
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    -- stylua: ignore
    keys = function()
      if vim.g.nvchad_use_dapui then
        return {
          { "<leader>d", "", desc = "Debug", mode = {"n", "v"} },
          { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Dap Breakpoint condition: ')) end, desc = "Dap Breakpoint Condition" },
          { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Dap Toggle Breakpoint" },
          { "<leader>dc", function() require("dap").continue() end, desc = "Dap Run/Continue" },
          -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
          {"<leader>dm", "", desc = "Dap Move"},
          { "<leader>dmC", function() require("dap").run_to_cursor() end, desc = "Dap Run to Cursor" },
          { "<leader>dmg", function() require("dap").goto_() end, desc = "Dap Go to Line (No Execute)" },
          { "<leader>dmi", function() require("dap").step_into() end, desc = "Dap Step Into" },
          { "<leader>dmj", function() require("dap").down() end, desc = "Dap Down" },
          { "<leader>dmk", function() require("dap").up() end, desc = "Dap Up" },
          { "<leader>dml", function() require("dap").run_last() end, desc = "Dap Run Last" },
          { "<leader>dmo", function() require("dap").step_out() end, desc = "Dap Step Out" },
          { "<leader>dO", function() require("dap").step_over() end, desc = "Dap Step Over" },
          { "<leader>dp", function() require("dap").pause() end, desc = "Dap Pause" },
          { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Dap Toggle REPL" },
          { "<leader>ds", function() require("dap").session() end, desc = "Dap Session" },
          { "<leader>dt", function() require("dap").terminate() end, desc = "Dap Terminate" },
          { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Dap Widgets" },
        }
      end
    end,
    --
    config = function()
      local dap_file_path = vim.fn.getcwd() .. "/.dap.lua"

      local file_type = vim.bo.filetype
      if file_type == "c" or file_type == "cpp" then
        require("dap.codelldb").setup()
      elseif file_type == "rust" then
        require("dap.codelldb-rs").setup()
        require("dap.cpptools").setup()
      elseif file_type == "python" then
        require("dap.debugpy").setup()
      elseif file_type == "cs" then
        require("dap.netcoredbg").setup()
      end
      -- load dap file from root
      local dap = require "dap"
      if vim.fn.filereadable(dap_file_path) == 1 then
        local _, config = pcall(dofile, dap_file_path)
        -- if not status then
        --   vim.notify("Error loading .dap.lua: " .. config, vim.log.levels.ERROR)
        --   return
        -- end
        --
        -- -- 检查配置是否有效
        -- if type(config) ~= "table" then
        --   vim.notify(".dap.lua must return a table", vim.log.levels.ERROR)
        --   return
        -- end

        -- 将配置合并到 dap.configurations 中
        for lang, conf in pairs(config) do
          -- 如果语言配置不存在，则初始化为空表
          dap.configurations[lang] = {}

          -- 如果配置是表的数组，则合并每个条目
          if type(conf) == "table" and vim.isarray(conf) then
            for _, entry in ipairs(conf) do
              table.insert(dap.configurations[lang], entry)
            end
          else
            -- 如果只是单个配置，直接添加
            table.insert(dap.configurations[lang], conf)
          end
        end
      end
      -- HighLight
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(require("configs.ui").icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  { "nvim-neotest/nvim-nio" },
}
