if vim.g.lsp_taplo_loaded then
  return
end

vim.g.lsp_taplo_loaded = true

vim.lsp.config("taplo", {
  name = "taplo",
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", "pyproject.toml", ".git" },
  -- settings = {
  --   taplo = {
  --     schema = {
  --       enabled = true,
  --       catalogs = { "https://www.schemastore.org/api/json/catalog.json" }, -- 默认已开，通常保留
  --       associations = {
  --         ["Cargo.toml"] = "taplo://cargo.toml",
  --         ["**/Cargo.toml"] = "taplo://cargo.toml",
  --         ["pyproject.toml"] = "https://json.schemastore.org/pyproject.json",
  --         ["**/pyproject.toml"] = "https://json.schemastore.org/pyproject.json",
  --         -- 加更多你常用的 glob/schema
  --         -- ["deno.json"]                  = "https://deno.land/x/deno/schema.json",
  --       },
  --     },
  --   },
  -- },
})
vim.lsp.enable "taplo"

local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)

-- 检查是否已附加
if #vim.lsp.get_clients { bufnr = bufnr, name = "taplo" } > 0 then
  return
end

vim.lsp.start {
  name = "taplo",
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = vim.fs.dirname(filename),
  single_file_support = true,
}
