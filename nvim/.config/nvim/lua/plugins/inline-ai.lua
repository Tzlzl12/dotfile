return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    opts = {
      server = {
        portal_url = "https://windsurf.com",
      },
      silent = true,
      filter = function(bufnr)
        local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        local bt = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
        if ft == "neo-tree" then
          return false
        end
        if ft == "neo-tree-popup" or bt == "prompt" or bt == "nofile" then
          return false
        end

        return vim.api.nvim_get_mode().mode ~= "c"
      end,
      filetype = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        codecompanion = false,
      },
    },
  },
  {
    "Exafunction/windsurf.nvim",
    enabled = false,
    cmd = "Codeium",
    event = "InsertEnter",
    lazy = true,
    build = ":Codeium Auth",
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        idle_delay = 200,
        key_bindings = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
    },
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
  },
}
