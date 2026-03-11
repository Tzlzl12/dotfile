local root_markers = { "taplo.toml", ".taplo.toml", "Cargo.toml", "pyproject.toml", ".git" }
return {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },

  root_markers = root_markers,
  settings = {
    evenBetterToml = {
      -- schema = {
      --   -- 自动从 SchemaStore 关联已知文件（Cargo.toml、pyproject.toml 等）
      --   associations = {
      --     ["Cargo.toml"] = "taplo://cargo",
      --     ["pyproject.toml"] = "taplo://pyproject",
      --     -- ["pyproject.toml"] = "https://json.schemastore.org/pyproject.json",
      --   },
      --   catalogs = {
      --     "https://www.schemastore.org/api/json/catalog.json",
      --   },
      -- },
      -- formatter = {
      --   alignEntries = false,
      --   arrayTrailingComma = true,
      --   arrayAutoExpand = true,
      --   arrayAutoCollapse = true,
      --   compactArrays = true,
      --   compactInlineTables = false,
      --   columnWidth = 80,
      --   indentTables = false,
      --   indentEntries = false,
      --   reorderKeys = false,
      -- },
    },
  },
}
-- return {
--   cmd = { "tombi", "lsp" },
--   filetypes = { "toml" },
--
--   root_markers = root_markers,
-- }
