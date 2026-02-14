# nvim

Neovim の設定ファイル。

## 構成

```
init.lua                    -- エントリポイント
lua/
  options.lua               -- vim.opt 設定
  keymaps.lua               -- キーマッピング
  autocmds.lua              -- autocommand
  plugins/
    init.lua                -- lazy.nvim ブートストラップ + プラグイン一覧
    lsp.lua                 -- LSP (vim.lsp.config / vim.lsp.enable)
    cmp.lua                 -- nvim-cmp 補完
    treesitter.lua          -- nvim-treesitter 構文解析
    neo-tree.lua            -- ファイラー
    telescope.lua           -- ファジーファインダー
    gitsigns.lua            -- Git 変更表示
    lualine.lua             -- ステータスライン
    which-key.lua           -- キーバインド表示
    conform.lua             -- フォーマッタ統合
    trouble.lua             -- 診断パネル
    claude-code.lua         -- Claude Code 連携
colors/
  hybrid.vim                -- カラースキーム
snippets/
  rust.snip                 -- Rust スニペット
```

## セットアップ

```bash
git clone https://github.com/hiro8ma/nvim.git ~/.config/nvim
nvim  # 初回起動で lazy.nvim + プラグインが自動インストールされる
```

## 対応言語

Go, Rust, TypeScript/JavaScript, Python, C, Dart/Flutter, Terraform

## 移行履歴

### dein (VimScript) → lazy.nvim (Lua) 移行

`dein-legacy` ブランチに移行前の設定を保存。

#### 変更内容

| 項目 | 旧 | 新 |
|------|-----|-----|
| エントリポイント | `init.vim` | `init.lua` |
| プラグインマネージャー | dein.vim + TOML | lazy.nvim |
| ファイラー | NERDTree | neo-tree.nvim |
| ファジーファインダー | fzf.vim | telescope.nvim |
| フォーマッタ | vim-prettier, vim-clang-format 等個別 | conform.nvim で統合 |
| ステータスライン | `statusline=%f%=` | lualine.nvim |
| LSP 設定 | `require("lspconfig").server.setup()` | `vim.lsp.config()` + `vim.lsp.enable()` (Neovim 0.11+) |
| Treesitter | なし | nvim-treesitter |
| Git 表示 | なし | gitsigns.nvim |

#### 新規追加プラグイン

- **nvim-treesitter** — 構文解析ベースのハイライト
- **gitsigns.nvim** — ガターに Git 変更行表示
- **lualine.nvim** — モード・ブランチ・診断数を表示するステータスライン
- **which-key.nvim** — キーバインド一覧ポップアップ
- **conform.nvim** — 言語別フォーマッタ統合 (format-on-save)
- **trouble.nvim** — LSP 診断の一覧パネル

#### 削除したプラグイン

- dein.vim, dein-command.vim (lazy.nvim に置換)
- NERDTree (neo-tree.nvim に置換)
- fzf, fzf.vim (telescope.nvim に置換)
- vim-prettier (conform.nvim に統合)
- vim-clang-format, vim-operator-user (conform.nvim に統合)
- vim-goimports (conform.nvim に統合)

#### 修正した非推奨 API

- `tsserver` → `ts_ls`
- `vim.lsp.diagnostic.*` → `vim.diagnostic.*`
- `require("lspconfig").setup()` → `vim.lsp.config()` + `vim.lsp.enable()`
- `require("nvim-treesitter.configs").setup()` → `require("nvim-treesitter").install()` + `vim.treesitter.start()`
