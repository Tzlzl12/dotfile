return {
  {
    "nvzone/showkeys",
    keys = {
      { "<leader>uk", ":ShowkeysToggle<cr>", desc = "UI Show KeysPress" },
    },
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      position = "top-right",
      -- more opts
    },
  },
}
