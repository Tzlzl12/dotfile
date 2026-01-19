-- 1. 获取当前缓冲区的 ID (ftplugin 脚本运行时，当前 buffer 就是目标)
local bufnr = vim.api.nvim_get_current_buf()
local filename = vim.api.nvim_buf_get_name(bufnr)

-- 2. 定义命令创建函数
local function create_tinymist_command(command_name, client, bufnr_arg)
  local export_type = command_name:match "tinymist%.export(%w+)"
  local info_type = command_name:match "tinymist%.(%w+)"
  local cmd_display = export_type or info_type:gsub("^get", "Get"):gsub("^pin", "Pin")

  local function run_tinymist_command()
    local current_filename = vim.api.nvim_buf_get_name(bufnr_arg)
    local title_str = export_type and ("Export " .. cmd_display) or cmd_display

    local function handler(err, res)
      if err then
        return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
      end
      if res then
        vim.notify(vim.inspect(res), vim.log.levels.INFO)
      end
    end

    -- Tinymist 特定的执行方式
    return client.request("workspace/executeCommand", {
      command = command_name,
      arguments = { current_filename },
    }, handler, bufnr_arg)
  end

  local cmd_name = export_type and ("TinymistExport" .. cmd_display) or ("Tinymist" .. cmd_display)
  local cmd_desc = export_type and ("Export to " .. cmd_display) or ("Get " .. cmd_display)
  return run_tinymist_command, cmd_name, cmd_desc
end

-- 3. 启动或连接 LSP
-- 注意：vim.lsp.start 会自动处理“如果已启动则 attach”的逻辑
vim.lsp.start {
  name = "tinymist",
  cmd = { "tinymist" },
  root_dir = vim.fs.root(bufnr, { ".git", "typst.toml" }) or vim.fs.dirname(filename),
  on_attach = function(client, b)
    -- 注册专属命令
    local commands = {
      "tinymist.exportSvg",
      "tinymist.exportPng",
      "tinymist.exportPdf",
      "tinymist.exportMarkdown",
      "tinymist.exportText",
      "tinymist.exportQuery",
      "tinymist.exportAnsiHighlight",
      "tinymist.getServerInfo",
      "tinymist.getDocumentTrace",
      "tinymist.getWorkspaceLabels",
      "tinymist.getDocumentMetrics",
      "tinymist.pinMain",
    }

    for _, command in ipairs(commands) do
      local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, b)
      vim.api.nvim_buf_create_user_command(b, "Lsp" .. cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
    end
  end,
}
