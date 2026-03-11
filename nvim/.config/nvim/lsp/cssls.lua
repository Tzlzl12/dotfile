local root_markers = { ".git" }
return {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
  root_dir = function(bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = fname })[1]
    return found and vim.fs.dirname(found) or vim.fs.dirname(fname)
  end,

  capabilities = {
    documentFormattingProvider = false,
    documentRangeFormattingProvider = false,
  },
}
