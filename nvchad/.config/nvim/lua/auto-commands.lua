vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text", -- 描述，可选
  pattern = "*", -- 适用于所有文件
  callback = function()
    (vim.hl or vim.highlight).on_yank() -- 调用高亮方法
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    require("conform").format {
      bufnr = args.buf,
      lsp_fallback = true, -- 如果没有设置格式化器，则使用 LSP 格式化
    }
  end,
})

-- 进入 Visual 模式时启用 listchars
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[vV\x16]", -- 匹配进入 Visual 模式
  callback = function()
    vim.opt.list = true -- 启用 listchars
  end,
})

-- 离开 Visual 模式时禁用 listchars
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[^vV\x16]", -- 匹配离开 Visual 模式
  callback = function()
    vim.opt.list = false -- 禁用 listchars
  end,
})

local blink_inline = vim.api.nvim_create_augroup("BlinkCmpCopilot", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = blink_inline,
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    if require("copilot.client").is_disabled() then
      require("codeium.virtual_text").clear()
    else
      vim.b.copilot_suggestion_hidden = true
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = blink_inline,
  pattern = "BlinkCmpMenuClose",
  callback = function()
    if require("copilot.client").is_disabled() then
    else
      vim.b.copilot_suggestion_hidden = false
    end
  end,
})
-- rust fmt
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- 配置clangd-extensions plugins
if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
  -- 加载 clangd_extensions
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Load clangd_extensions with clangd",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "clangd" then
        require "clangd_extensions"
        vim.api.nvim_del_augroup_by_name "clangd_extensions" -- 删除自动组，避免重复加载
      end
    end,
  })

  -- 设置 clangd 的快捷键
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Load clangd_extension_mappings with clangd",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "clangd" then
        -- 设置快捷键
        local opts = { buffer = args.buf }
        vim.keymap.set(
          "n",
          "<Leader>lh",
          "<Cmd>ClangdSwitchSourceHeader<CR>",
          { desc = "Switch source/header file", buffer = opts.buffer }
        )
      end
    end,
  })
end
