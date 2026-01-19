local prefix = "<leader>a"

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },

  -- 使用 opts 代替 config
  opts = function()
    -- 只有在需要用到内置适配器扩展时才在这里 require
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
                  default = "Qwen/Qwen3-Coder-480B-A35B-Instruct",
                  choices = {
                    ["Qwen/Qwen3-Coder-480B-A35B-Instruct"] = { formatted_name = "Qwen3 Coder 480B" },
                    ["ZhipuAI/GLM-4.7"] = { formatted_name = "GLM-4.7" },
                    ["qwen/Qwen2.5-Coder-32B-Instruct"] = { formatted_name = "Qwen2.5 Coder 32B" },
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
        chat = { adapter = "modelscope" },
        inline = { adapter = "modelscope", model = "ZhipuAI/GLM-4.7" },
        agent = { adapter = "modelscope" },
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
    { prefix .. "a", mode = { "n", "x" }, "<cmd>CodeCompanion<cr>", desc = "AI Ask" },
    -- 这里的 Toggle 已经按照你之前的要求配置好了
    { prefix .. "c", mode = { "n", "x" }, "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat Toggle" },
    { prefix .. "x", mode = { "n" }, "<cmd>CodeCompanionActions<cr>", desc = "AI Menu" },
  },
}
