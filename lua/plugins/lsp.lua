return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- LSP アタッチ時のキーマップ
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "<C-]>", function()
          vim.cmd("vsplit")
          vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "<C-j>", function()
          vim.cmd("vsplit")
          vim.lsp.buf.implementation()
        end, opts)
        vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<C-a>", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<C-n>", vim.diagnostic.goto_next, opts)

        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

        -- ドキュメントハイライト
        if client and client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
          vim.api.nvim_create_autocmd("CursorHold", {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    -- サーバー設定
    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git" },
    })

    vim.lsp.enable({
      "gopls",
      "rust_analyzer",
      "pylsp",
      "clangd",
      "ts_ls",
    })
  end,
}
