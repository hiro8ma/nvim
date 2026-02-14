-- lazy.nvim ブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- インデントガイド
  {
    "nathanaelkane/vim-indent-guides",
    config = function()
      vim.g.indent_guides_enable_on_vim_startup = 1
      vim.g.indent_guides_color_change_percent = 6
      vim.g.indent_guides_auto_colors = 0
      vim.g.indent_guides_guide_size = 2
      vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "IndentGuidesOdd", { ctermbg = 236 })
          vim.api.nvim_set_hl(0, "IndentGuidesEven", { ctermbg = 237 })
        end,
      })
    end,
  },

  -- 行末スペース可視化
  { "bronson/vim-trailing-whitespace" },

  -- スニペット
  {
    "Shougo/neosnippet.vim",
    dependencies = { "Shougo/neosnippet-snippets" },
    config = function()
      vim.g["neosnippet#snippets_directory"] = "~/.config/nvim/snippets"
      vim.g["neosnippet#enable_snipmate_compatibility"] = 1
      vim.keymap.set("i", "<C-k>", "<Plug>(neosnippet_expand_or_jump)")
      vim.keymap.set("s", "<C-k>", "<Plug>(neosnippet_expand_or_jump)")
      vim.keymap.set("x", "<C-k>", "<Plug>(neosnippet_expand_target)")
      if vim.fn.has("conceal") == 1 then
        vim.opt.conceallevel = 2
        vim.opt.concealcursor = "niv"
      end
    end,
  },

  -- 補完 (nvim-cmp)
  require("plugins.cmp"),

  -- LSP
  require("plugins.lsp"),

  -- Treesitter
  require("plugins.treesitter"),

  -- neo-tree (NERDTree 置換)
  require("plugins.neo-tree"),

  -- telescope (fzf.vim 置換)
  require("plugins.telescope"),

  -- cellwidths (ambiwidth 代替: 日本語記号を個別に2セル幅に)
  require("plugins.cellwidths"),

  -- claude-code.nvim
  require("plugins.claude-code"),

  -- gitsigns
  require("plugins.gitsigns"),

  -- lualine (ステータスライン)
  require("plugins.lualine"),

  -- which-key (キーバインド表示)
  require("plugins.which-key"),

  -- conform (フォーマッタ統合)
  require("plugins.conform"),

  -- trouble (診断パネル)
  require("plugins.trouble"),

  -- Rust
  {
    "rust-lang/rust.vim",
    ft = "rust",
  },

  -- EditorConfig
  { "editorconfig/editorconfig-vim" },

  -- Go
  { "fatih/vim-go" },
  { "mattn/vim-goaddtags" },

  -- コメント (gcc)
  { "tpope/vim-commentary" },

  -- Terraform
  { "hashivim/vim-terraform" },

  -- Flutter
  { "akinsho/flutter-tools.nvim" },

  -- Git
  { "tpope/vim-fugitive" },

  -- Copilot
  { "github/copilot.vim" },
})
