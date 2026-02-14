return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { ",a", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { ",f", "<cmd>Telescope git_files<CR>", desc = "Git Files" },
    { ",b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { ",m", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
  },
  config = function()
    require("telescope").setup({})
  end,
}
