if not vim.g.vscode then
  vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent line" })
  vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent line" })
  -- 注释切换
  vim.keymap.set("n", "<C-/>", function()
    require("vscode-neovim").action "editor.action.commentLine"
  end, { desc = "Toggle comment line" })

  vim.keymap.set("v", "<C-/>", function()
    require("vscode-neovim").action "editor.action.commentLine"
  end, { desc = "Toggle comment block" })

  -- 文件资源管理器
  vim.keymap.set("n", "<C-n>", function()
    require("vscode-neovim").action "workbench.view.explorer"
  end, { desc = "Toggle Explorer" })

  vim.keymap.set("n", "<leader>bx", function()
    require("vscode-neovim").action "workbench.action.closeOtherEditors"
  end, { desc = "Close other editors" })

  local enabled = {}
  vim.tbl_map(function(plugin)
    enabled[plugin] = true
  end, {
    -- core plugins
    "lazy.nvim",
    "nvim-treesitter",
    "nvim-ts-context-commentstring",
    -- more known working
    "flash.nvim",
    "mini.ai",
    "mini.comment",
    -- "mini.move",
    "mini.pairs",
    "mini.surround",
    "toggleterm.nvim",
    "gitsigns.nvim",
  })

  local Config = require "lazy.core.config"
  -- disable plugin update checking
  Config.options.checker.enabled = false
  Config.options.change_detection.enabled = false
  -- replace the default `cond`
  Config.options.defaults.cond = function(plugin)
    return enabled[plugin.name]
  end
end -- don't do anything in non-vscode instances

---@type LazySpec
return {
  { "nvim-treesitter/nvim-treesitter", opts = { highlight = { enable = false } } },
}
