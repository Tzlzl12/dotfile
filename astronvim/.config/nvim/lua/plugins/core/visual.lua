local v = {
  ["<c-_>"] = { "gc", remap = true, desc = "Comment block" },
  ["<a-down>"] = {
    ":m '>+1<cr>gv=gv",
    desc = "Move Down",
  },
  ["<a-up>"] = {
    ":m '<-2<cr>gv=gv",
    desc = "Move Up",
  },
  ["<tab>"] = { ">gv", desc = "Indent line" },
  ["<s-tab>"] = { "<gv", desc = "Unindent line" },
}

return v
