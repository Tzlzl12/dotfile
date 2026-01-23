local prefix = "<leader>a"

return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },

  opts = function()
    local adapters = require "codecompanion.adapters"

    return {
      adapters = {
        http = {
          modelscope = function()
            return adapters.extend("openai_compatible", {
              name = "modelscope",
              formatted_name = "ModelScope",
              url = "https://api-inference.modelscope.cn/v1/chat/completions",
              env = {
                api_key = "MODELSCOPE_API_KEY",
              },
              headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer ${api_key}",
              },
              schema = {
                model = {
                  order = 1,
                  mapping = "parameters",
                  type = "enum",
                  default = "ZhipuAI/GLM-4.7",
                  choices = {
                    ["ZhipuAI/GLM-4.7"] = { formatted_name = "GLM-4.7" },
                    ["Qwen/Qwen3-Coder-480B-A35B-Instruct"] = { formatted_name = "Qwen3 Coder 480B" },
                    ["qwen/Qwen2.5-Coder-32B-Instruct"] = { formatted_name = "Qwen2.5 Coder 32B" },
                    ["deepseek-ai/DeepSeek-V3.2"] = { formatted_name = "DeepSeek V3.2" },
                  },
                },
                temperature = { type = "number", default = 1 },
                max_tokens = { type = "integer", default = 8192 },
              },
            })
          end,
        },
      },
      strategies = {
        chat = { adapter = "opencode", model = "deepseek-ai/DeepSeek-V3.2" },
        inline = { adapter = "modelscope", model = "ZhipuAI/GLM-4.7" },
        agent = { adapter = "opencode", model = "qwen/Qwen2.5-Coder-32B-Instruct" },
      },
      display = {
        action_palette = { width = 95, height = 10, prompt = "> " },
        chat = { window = { width = 0.4 } },
        diff = { enabled = true, layout = "buffer" },
        inline = { layout = "buffer" },
      },
      opts = {
        log_level = "WARN",
        language = "Chinese",
      },
      keymaps = {
        inline = {
          accept_change = {
            modes = { n = "ga" }, -- 改成 ga 接受（g = git-like, a = accept）
          },
          reject_change = {
            modes = { n = "gr" }, -- 改成 gr 拒绝
          },
        },
      },
    }
  end,

  -- config 这一行可以完全删掉，lazy 会自动调用 setup 并传入上面的 opts

  keys = {
    { prefix .. "a", mode = { "n", "x" }, ":CodeCompanion ", desc = "AI Ask" },
    -- -- 这里的 Toggle 已经按照你之前的要求配置好了
    -- { prefix .. "c", mode = { "n" }, "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat Toggle" },
    { prefix .. "m", mode = { "n" }, "<cmd>CodeCompanionActions<cr>", desc = "AI Menu" },
    -- { prefix .. "x", mode = { "x", "v" }, "<cmd>CodeCompanionChat Add<cr>", desc = "AI Add Text" },
  },
}
