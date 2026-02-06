if true then
  return {}
end
-- plugins/completion.lua 或 plugins/mini.lua
local function map() end

return {
  -- 只装 mini.completion（补全引擎）
  {
    "echasnovski/mini.completion",
    event = "InsertEnter",
    opts = {
      delay = {
        completion = 100, -- 输入停止后多久弹出补全
        info = 100, -- 弹出补全后多久显示右侧文档窗口
        signature = nil,
      },
      window = {
        info = { border = "rounded", width = 30, height = 5 },
        signature = nil,
      },

      -- 3. LSP 相关配置
      lsp_completion = {
        source_func = "completefunc",
        auto_setup = true,
        process_items = function(items, base)
          -- 1. 首先获取默认处理后的列表（已包含过滤、排序和图标）
          local processed = MiniCompletion.default_process_items(items, base)

          -- 2. 遍历每个项，注入 colorful-menu 的高亮逻辑
          for _, item in ipairs(processed) do
            local completion_item = item.lsp_item

            if completion_item then
              local highlights_info = require("colorful-menu").blink_highlights(completion_item, vim.bo.filetype)

              if highlights_info then
                item.abbr = highlights_info.text
                item.abbr_hlgroup = highlights_info.highlights
              end
            end

            -- 3. 仿照你给的代码，清理 menu 字段（可选）
            item.menu = ""
          end
          return processed
        end,
      },

      fallback_action = function()
        vim.opt.complete = ".,b,w"

        local col = vim.api.nvim_win_get_cursor(0)[2]

        if col < 3 then
          return
        end
        return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
      end,

      mappings = {
        force_twoway = false, -- 是否强制双向导航
      },

      set_vim_settings = false, -- 是否让插件自动修改 completeopt 等系统设置
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
          local bt = vim.bo[args.buf].buftype
          local ft = vim.bo[args.buf].filetype

          if bt == "prompt" or ft == "snacks_picker_input" then
            vim.b[args.buf].minicompletion_disable = true
          end
        end,
      })
      require("mini.completion").setup(opts)
      vim.opt.pumheight = 6
    end,
  },

  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      -- require("mini.pairs").setup(opts)
      local pairs = require "mini.pairs"
      pairs.setup {}

      vim.keymap.set("i", "<CR>", function()
        return pairs.cr()
      end, { expr = true, replace_keycodes = true })
      pairs.setup(opts)
    end,
  },

  {
    "xzbdmw/colorful-menu.nvim",
    opts = {
      max_width = 30,
      -- 决定对齐方式
      ls = {
        lua_ls = {
          -- Maybe you want to dim arguments a bit.
          arguments_hl = "@comment",
        },
        ["rust-analyzer"] = {
          -- Such as (as Iterator), (use std::io).
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        clangd = {
          -- Such as "From <stdio.h>".
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- the hl group of leading dot of "•std::filesystem::permissions(..)"
          import_dot_hl = "@comment",
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        zls = {
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
        },
      },
    },
  },
}
