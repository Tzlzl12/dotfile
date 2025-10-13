local n = {
  [";"] = { ":" },
  ["q"] = { ":q<cr>", desc = "quit" },
  ["jj"] = { "5j" },
  ["kk"] = { "5k" },

  ["<tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  ["<s-tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
  -- mappings seen under group name "Buffer"

  ["<a-down>"] = { "<cmd>m .+1<cr>==", desc = "Move Down" },
  ["<a-up>"] = { "<cmd>m .-2<cr>==", desc = "Move Up" },

  ["<c-_>"] = { "gcc", remap = true, desc = "Toggle comment line" },

  ["<c-n>"] = {
    function()
      require("neo-tree.command").execute {
        toggle = true,
      }
    end,
    desc = "Toggle Explorer",
  },
  -- ["<leader>l"] = { ":Lazy<cr>", desc = "Lazy" },
  ["<esc>"] = { function() require("noice").cmd "dismiss" end, desc = "Noice Dismiss" },
  ["<c-space>"] = {
    -- "<Cmd>ToggleTerm direction=float<CR>",
    function()
      local str = "ToggleTerm direction=float"
      -- require("astrocore").notify(root, 2)
      vim.cmd(str)
    end,
    remap = true,
    desc = "Toggle Terminal",
  },

  -- lsp
  ["<leader>cd"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
  ["<leader>ca"] = { "<leader>la", remap = true, desc = "LSP code action" },
  ["gh"] = { function() vim.lsp.buf.hover() end, desc = "LSP Docs Hover" },
  ["K"] = {},
  ["gi"] = {
    function() vim.lsp.buf.implementation() end,
    desc = "Implementation to the current symbol",
    remap = true,
  },

  ["<leader>cm"] = { ":Mason<cr>", desc = "Mason UI" },

  -- buffer
  ["<leader>x"] = { "<leader>c", desc = "Close Current Buffer", remap = true },
  ["<Leader>bd"] = {
    function()
      require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
    end,
    desc = "Close buffer from tabline",
  },

  ["<leader>rc"] = { ":RunCode<cr>", desc = "Run Code" },
  -- fanyi
  ["<leader>tr"] = {
    function()
      local fanyi = require "plugins.core.fanyi"
      fanyi()
    end,
  },
  -- replace word
  ["rw"] = {
    function()
      local replace = require "plugins.core.replace_word"
      replace()
    end,
  },
}
return n
