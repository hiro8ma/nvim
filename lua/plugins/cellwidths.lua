return {
  "delphinus/cellwidths.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cellwidths").setup({
      name = "default",
    })
  end,
}
