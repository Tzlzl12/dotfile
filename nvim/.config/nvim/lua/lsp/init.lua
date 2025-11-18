local map = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- dofile(vim.g.base46_cache .. "lsp")
    -- keymap
    local lsp_action = nil
    if vim.g.nvchad_use_telescope then
      lsp_action = require "telescope.builtin"
    else
      lsp_action = Snacks.picker
    end
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf
    local function opts(desc)
      return { buffer = bufnr, desc = "Lsp " .. desc }
    end
    -- 为所有支持 CodeLens 的 LSP 客户端启用 CodeLens
    if client and client.server_capabilities.codeLensProvider then
      -- 启用 CodeLens
      vim.lsp.codelens.refresh()

      -- 设置刷新 CodeLens 的快捷键
      map("n", "<leader>cl", vim.lsp.codelens.run, opts "Run CodeLens")
      map("n", "<leader>cL", vim.lsp.codelens.refresh, opts "Refresh CodeLens")

      -- 设置自动刷新 CodeLens
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
      })
    end

    require "keymap.goto"
    map("n", "gh", function()
      if (client and client.name == "clangd") or (client and client.name == "ccls") then
        return require("pretty_hover").hover()
      else
        return vim.lsp.buf.hover {
          border = "rounded",
        }
      end
    end, opts "Hover")

    require "keymap.lsp"
    -- map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts "List workspace folders")

    map("n", "<leader>cd", function()
      vim.diagnostic.open_float(nil, {
        border = "rounded",
        -- documentationFormat = "markdown",
      })
    end, opts " Diagnostics")
    map("n", "gr", lsp_action.lsp_references, opts "Show references")

    -- inlay_hints
    if vim.fn.has "nvim-0.10" == 1 then
      -- in Insert mode disable inlay_hint
      vim.api.nvim_create_autocmd("ModeChanged", {
        callback = function()
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            local mode = vim.api.nvim_get_mode().mode
            if mode == "n" then
              -- 严格进入 Normal 模式
              vim.g.inlay_hints_visible = true
              vim.lsp.inlay_hint.enable(true)
            else
              -- 其他模式都隐藏
              vim.g.inlay_hints_visible = false
              vim.lsp.inlay_hint.enable(false)
            end
          end
        end,
      })
      -- vim.api.nvim_create_autocmd("InsertEnter", {
      -- 	callback = function()
      -- 		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      -- 			vim.g.inlay_hints_visible = false
      -- 			vim.lsp.inlay_hint.enable(false)
      -- 		end
      -- 	end,
      -- })
      -- --  leave Insert mode disable inlay_hint
      -- vim.api.nvim_create_autocmd("InsertLeave", {
      -- 	callback = function()
      -- 		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      -- 			vim.g.inlay_hints_visible = true
      -- 			vim.lsp.inlay_hint.enable(true)
      -- 		end
      -- 	end,
      -- })
      vim.g.inlay_hints_visible = true
      vim.lsp.inlay_hint.enable(true)
    end
    -- folding
    if client and client:supports_method "textDocument/foldingRange" then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
    if
      client
      and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
      and vim.bo.filetype ~= "bigfile"
    then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
          -- vim.cmd 'setl foldexpr <'
        end,
      })
    end

    -- diagnostics
    local diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "󱓻",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = require("configs.icons").icons.dia.Error,
          [vim.diagnostic.severity.WARN] = require("configs.icons").icons.dia.Warn,
          [vim.diagnostic.severity.HINT] = require("configs.icons").icons.dia.Hint,
          [vim.diagnostic.severity.INFO] = require("configs.icons").icons.dia.Info,
        },
      },
    }

    vim.diagnostic.config(diagnostics)

    -- signature
    vim.schedule(function()
      if client then
        local signatureProvider = client.server_capabilities.signatureHelpProvider
        if signatureProvider and signatureProvider.triggerCharacters then
          require("lsp.utils.signature").setup(client, event.buf)
          -- require("nvchad.lsp.signature").setup(client, event.buf)
        end
      end
    end)
  end,
})
-- return M
