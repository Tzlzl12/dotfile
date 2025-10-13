local ignore_filetypes = {
  "aerial",
  "alpha",
  "dashboard",
  "help",
  "lazy",
  "mason",
  "neo-tree",
  "NvimTree",
  "neogitstatus",
  "notify",
  "startify",
  "toggleterm",
  "Trouble",
}

local ignore_buftypes = {
  "nofile",
  "prompt",
  "quickfix",
  "terminal",
}

-- 禁用 mini.indentscope 对于某些 filetype
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable indentscope for certain filetypes",
  callback = function(event)
    if vim.b[event.buf].miniindentscope_disable == nil then
      local filetype = vim.bo[event.buf].filetype
      if vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[event.buf].miniindentscope_disable = true
      end
    end
  end,
})

-- 禁用 mini.indentscope 对于某些 buftype
vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Disable indentscope for certain buftypes",
  callback = function(event)
    if vim.b[event.buf].miniindentscope_disable == nil then
      local buftype = vim.bo[event.buf].buftype
      if vim.tbl_contains(ignore_buftypes, buftype) then
        vim.b[event.buf].miniindentscope_disable = true
      end
    end
  end,
})

-- 禁用 mini.indentscope 对于终端
vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Disable indentscope for terminals",
  callback = function(event)
    if vim.b[event.buf].miniindentscope_disable == nil then
      vim.b[event.buf].miniindentscope_disable = true
    end
  end,
})
local char = "▏"
return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPost" },
  opts = function()
    return {
      options = { try_as_border = true },
      symbol = char,
    }
  end,
  dependencies = {
    {
      "lukas-reineke/indent-blankline.nvim",
      -- optional = true,
      -- event = { "BufReadPost" },
      opts = { scope = { enabled = false } },
    },
  },
}
