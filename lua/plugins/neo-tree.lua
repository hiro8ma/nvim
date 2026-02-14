return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
      },
    })
    vim.keymap.set("n", "<C-e>", ":Neotree toggle reveal<CR>", { silent = true })

    -- 起動時に自動で開く
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd("Neotree show")
      end,
    })
  end,
}
