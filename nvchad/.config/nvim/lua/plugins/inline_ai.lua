return {
  {
    "Exafunction/windsurf.nvim",
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
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = true,
    build = ":Copilot auth",
    event = "InsertEnter",
    keys = {
      {
        "<leader>ua",
        function()
          if require("copilot.client").is_disabled() then -- copilot is disable
            require("copilot.command").enable()
            require("codeium.api"):disable()
          else
            require("copilot.command").disable()
            require("codeium.api"):enable()
          end
        end,
        mode = "n",
        desc = "UI Toggle Inline Ai",
      },
    },
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 200,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
      },
      root_dir = function()
        require("utils").get_root_dir()
      end,
      server = {
        type = "nodejs", -- "nodejs" | "binary"
        custom_server_filepath = nil,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      require("copilot.command").disable()
    end,
  },
}
