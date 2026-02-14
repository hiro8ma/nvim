return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
        python = { "black" },
        c = { "clang-format" },
        dart = { "dart_format" },
        terraform = { "terraform_fmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        yaml = { "prettier" },
        toml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    })
  end,
}
