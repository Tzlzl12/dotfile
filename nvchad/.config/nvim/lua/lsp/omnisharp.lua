local M = {}
if not vim.g.nvchad_lsp.omnisharp then
  M.defaults = function() end
  return M
end

local handler = {
  ["textDocument/definition"] = function(...)
    return require("omnisharp_extended").handler(...)
  end,
}

local keys = {
  {
    "gd",
    function()
      require("omnisharp_extended").telescope_lsp_definitions()
    end,
    desc = "Goto Definition",
  },
}

M.defaults = function()
  vim.lsp.config("omnisharp", {
    cmd = {
      "omnisharp",
      "-lsp",
      "-z",
      "-e",
      "utf-8",
      "--stdio",
    },
    -- handlers = handler,
    -- keys = keys,
    -- settings = {
    --   omnisharp = { -- omnisharp 自身的设置通常嵌套在 'omnisharp' 键下
    --     EnableRoslynAnalyzers = true, -- 请根据 omnisharp 文档确认正确的字段名和大小写
    --     OrganizeImportsOnFormat = true,
    --     EnableImportCompletion = true,
    --   },
    -- },
  })
  vim.lsp.enable "omnisharp"
end

return M
