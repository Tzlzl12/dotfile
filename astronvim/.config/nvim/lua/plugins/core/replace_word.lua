local replace_word = function()
  local input = require "nui.input"
  -- local event = require("nui.utils.autocmd").event
  -- 获取光标下的单词
  local current_word = vim.fn.expand "<cword>"
  -- 设置高亮组以定义背景颜色

  -- local colors = require("tokyonight.colors").setup()
  -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue, bg = colors.bg }) -- 边框颜色
  -- vim.api.nvim_set_hl(0, "PopupTitle", { fg = colors.fg, bg = colors.bg }) -- 顶部文本颜色
  -- vim.api.nvim_set_hl(0, "FloatTitle", { fg = colors.orange, bg = colors.bg })
  -- 创建输入框
  local input_box = input({
    position = {
      row = 5, -- 屏幕顶部偏下的位置，调整数字可以改变高度
      col = "50%", -- 屏幕水平居中
    },
    size = {
      width = "50%",
    },
    border = {
      style = "rounded", -- 使用圆角边框
      text = {
        top = " Replace: " .. current_word .. " ",
        top_align = "left",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
    },
  }, {
    prompt = "> ",
    default_value = "", -- 清空默认内容
    on_submit = function(new_word)
      -- 替换光标下的单词
      vim.cmd(string.format("normal! ciw%s", new_word))
    end,
  })

  -- 打开输入框
  input_box:mount()

  -- 按 Esc 键关闭输入框
  input_box:map("i", "<Esc>", function() input_box:unmount() end)
end

return replace_word
