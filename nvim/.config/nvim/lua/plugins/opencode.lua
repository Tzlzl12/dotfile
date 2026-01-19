local prefix = "<leader>a"
local keymap = {
  editor = {
    [prefix .. "t"] = { "toggle" },
    [prefix .. "i"] = { "open_input" },
    [prefix .. "s"] = { "select_session" },
    [prefix .. "m"] = { "configure_provider" },
    [prefix .. "d"] = { "diff_open" },
    ["[a"] = { "diff_prev" },
    ["]a"] = { "diff_next" },
    [prefix .. "pa"] = { "permission_accept" },
    [prefix .. "pA"] = { "permission_accept_all" },
    [prefix .. "pd"] = { "permission_deny" },
    [prefix .. "x"] = { "toggle_tool_output" },
    [prefix .. "a"] = { "quick_chat", mode = { "n", "x" } },
  },
  output_window = {
    ["<esc>"] = { "close" },
    ["<C-c>"] = { "cancel" },
    ["]a"] = { "next_message" },
    ["[a"] = { "prev_message" },
    ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
    ["i"] = { "focus_input", "n" },
    ["a"] = { "focus_input", "n" },
  },
  history_picker = {
    delete_entry = { "<C-d>", mode = { "i", "n" } },
    clear_all = { "<C-D>", mode = { "i", "n" } },
  },
}

return {
  "sudo-tee/opencode.nvim",
  enabled = false,
  cmd = "Opencode",
  opts = {
    preferred_picker = "snacks",
    preferred_completion = "blink",
    -- defalut_global_keymaps = false,
    default_mode = "plan",
    keymap = {
      editor = keymap.editor,
      output_window = keymap.output_window,
      history_picker = keymap.history_picker,
    },
    ui = {
      input_height = 0.3,
      completion = { file_sources = { preferred_cli_tool = "fd" } },
    },
  },
  config = function(_, opts)
    require("opencode").setup(opts)
  end,
    -- stylua: ignore
  keys = {
    -- toggle chat 
    { prefix .. "t",  function() require("opencode").toggle()             end, desc = "AI Toggle" },
    { prefix .. "i",  function() require("opencode").open_input()         end, desc = "AI Open Input" },
    { prefix .. "s",  function() require("opencode").select_session()     end, desc = "AI Select Session" },

    { prefix .. "m",  function() require("opencode").configure_provider() end, desc = "AI Configure Provider" },

    { prefix .. "d",  function() require("opencode").diff_open()          end, desc = "AI Open Diff" },
    { "[a",           function() require("opencode").diff_prev()          end, desc = "AI Diff Previous" },
    { "]a",           function() require("opencode").diff_next()          end, desc = "AI Diff Next" },
    -- permissions
    { prefix .. "pa", function() require("opencode").permission_accept()     end, desc = "AI Permission Accept" },
    { prefix .. "pA", function() require("opencode").permission_accept_all() end, desc = "AI Permission Accept All" },
    { prefix .. "pd", function() require("opencode").permission_deny()       end, desc = "AI Permission Deny" },

    { prefix .. "x",  function() require("opencode").toggle_tool_output() end, desc = "AI Toggle Tool Output" },
    { prefix .. "a",  function() require("opencode").quick_chat() end, mode = { "n", "x" }, desc = "AI Quick Chat" },
  },
  --
}
