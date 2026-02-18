return {
  "preservim/nerdtree",
  config = function()
    vim.g.NERDTreeShowHidden = 1
    vim.keymap.set("n", "<C-e>", ":NERDTreeToggle<CR>", { silent = true })

    -- 起動時に自動で開く
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.cmd("NERDTree")
      end,
    })
  end,
}
