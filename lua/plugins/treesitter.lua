return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "go", "rust", "typescript", "tsx", "javascript",
      "python", "c", "dart", "hcl", "terraform",
      "lua", "vim", "vimdoc", "yaml", "toml", "json",
      "markdown", "markdown_inline", "bash", "css", "scss", "html",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
      end,
    })
  end,
}
