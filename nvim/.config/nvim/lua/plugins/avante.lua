return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  enabled = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "opencode",

    providers = {
      ["modelscope"] = {
        __inherited_from = "openai",
        endpoint = "https://api-inference.modelscope.cn/v1",
        api_key_name = "MODELSCOPE_API_KEY",

        model = "ZhipuAI/GLM-4.7",

        model_names = {
          "ZhipuAI/GLM-4.7", -- GLM-4.7
          "Qwen/Qwen3-Coder-480B-A35B-Instruct",
          "deepseek-ai/DeepSeek-V3.2",
        },

        extra_request_body = {
          temperature = 0.7,
          max_tokens = 8192,
          top_p = 0.9,
          stream = true,
        },
      },
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-3-flash",
        timeout = 30000,
        context_window = 1048576,
        use_ReAct_prompt = true,
        model_names = {
          "gemini-3-pro-preview",
          "gemini-3-flash",
          "gemini-2.5-pro",
          "gemini-2.5-flash",
        },
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
          top_p = 0.95,
          stream = true,
        },
      },
    },
    acp_providers = {
      ["opencode"] = {
        command = "opencode",
        args = { "acp" },
      },
    },
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = false,
      auto_add_current_file = false,
      enable_cursor_planning_mode = true,
    },

    windows = {
      position = "right", -- 侧边栏位置
      width = 40,
      ask = { floating = true },
    },

    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      focus = "<leader>af",
    },
    highlights = {
      diff = {
        current = "DiffDelete",
        incoming = "DiffAdd",
      },
    },
    hints = { enabled = true },
  },
  dependencies = {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "Avante" },
    },
  },
}
