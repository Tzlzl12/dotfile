local prefix = "<leader>a"
local keymap = {
  editor = {
    [prefix .. "t"] = { "toggle", desc = "AI Toggle" },
    [prefix .. "i"] = { "open_input", desc = "AI Open Input" },
    [prefix .. "s"] = { "select_session", desc = "AI Select Session" },
    [prefix .. "m"] = { "configure_provider", desc = "AI Configure Provider" },
    [prefix .. "d"] = { "diff_open", desc = "AI Open Diff" },
    ["[a"] = { "diff_prev", desc = "AI Diff Previous" },
    ["]a"] = { "diff_next", desc = "AI Diff Next" },
    [prefix .. "pa"] = { "permission_accept", desc = "AI Permission Accept" },
    [prefix .. "pA"] = { "permission_accept_all", desc = "AI Permission Accept All" },
    [prefix .. "pd"] = { "permission_deny", desc = "AI Permission Deny" },
    [prefix .. "x"] = { "toggle_tool_output", desc = "AI Toggle Tools" },
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
  cmd = "Opencode",
  opts = {
    -- preferred_picker = "snacks",
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
      input = { text = { wrap = true } },
    },
  },
  config = function(_, opts)
    require("opencode").setup(opts)
  end,
    -- stylua: ignore
  keys = {
    -- toggle chat 
    { prefix .. "t",  function() require("opencode").toggle()             end, desc = "AI Toggle" },
    { prefix .. "s",  function() require("opencode").select_session()     end, desc = "AI Select Session" },
    { prefix .. "d",  function() require("opencode").diff_open()          end, desc = "AI Open Diff" },
    { prefix .. "x",  function() require("opencode").toggle_tool_output() end, desc = "AI Toggle Tool Output" },
  },
  --
}
