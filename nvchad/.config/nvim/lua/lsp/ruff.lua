local function organize_imports()
  ---@diagnostic disable-next-line: param-type-mismatch
  local params = vim.lsp.util.make_range_params(nil, vim.api.nvim_get_current_buf())
  ---@diagnostic disable-next-line: inject-field
  params.context = { only = { "source.organizeImports" } }

  local clients = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf() }
  for _, client in ipairs(clients) do
    if client.supports_method "textDocument/codeAction" then
      vim.lsp.buf.execute_command {
        command = "source.organizeImports",
        arguments = { params.textDocument },
      }
      return
    end
  end
  -- vim.notify("Organize Imports is not supported by the active LSP", vim.log.levels.WARN)
end

local keys = {
  {
    "<leader>lh",
    function()
      organize_imports()
    end,
    desc = "Organize Imports",
  },
}

local init_options = {
  settings = {
    configuration = "~/.config/ruff/ruff.toml",
    -- configurationPreference = "filesystemFirst",
    lineLength = 100,
    logLevel = "warn",
  },
}

local server_capabilities = {
  hoverProvider = false,
}

return {
  cmd = { "ruff", "server" },
  filetype = { "python" },
  keys = keys,
  init_options = init_options,
  server_capabilities = server_capabilities,
}
