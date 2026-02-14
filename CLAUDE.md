# Neovim 設定 — Claude Code スキル

このリポジトリは Neovim の設定ファイル。変更時は以下の規約に従うこと。

## アーキテクチャ

- エントリポイントは `init.lua`。`options`, `keymaps`, `autocmds`, `plugins` を require するだけ
- プラグインは `lua/plugins/` 以下に1プラグイン1ファイルで配置
- 各プラグインファイルは lazy.nvim のプラグインスペック（テーブル）を `return` する
- プラグインマネージャーは **lazy.nvim**。`lua/plugins/init.lua` でブートストラップ

## 規約

### プラグイン追加手順
1. `lua/plugins/<name>.lua` を作成し、lazy.nvim スペックを `return` する
2. `lua/plugins/init.lua` の `require("lazy").setup({})` 内に `require("plugins.<name>")` を追加

### プラグイン設定の書き方
```lua
-- lua/plugins/example.lua
return {
  "author/plugin-name",
  dependencies = { "dep/plugin" },  -- 依存があれば
  ft = "go",                         -- 遅延読み込み条件（任意）
  config = function()
    require("plugin-name").setup({})
  end,
}
```

### LSP サーバー追加手順
- `lua/plugins/lsp.lua` の `vim.lsp.enable({})` リストにサーバー名を追加
- Neovim 0.11+ の `vim.lsp.config()` / `vim.lsp.enable()` を使用（`require("lspconfig")` は非推奨）

### フォーマッタ追加手順
- `lua/plugins/conform.lua` の `formatters_by_ft` にファイルタイプとフォーマッタを追加
- 個別のフォーマッタプラグインは追加しない（conform.nvim で統合）

### キーマッピング
- プラグイン固有でないグローバルなキーマップは `lua/keymaps.lua` に記述
- LSP キーマップは `lua/plugins/lsp.lua` の `LspAttach` autocmd 内
- プラグイン固有のキーマップは各プラグインファイルの `config` 内か `keys` スペック

### オプション設定
- `vim.opt.*` は `lua/options.lua` に記述
- autocommand は `lua/autocmds.lua` に記述

## API の注意点（Neovim 0.11+）

- Treesitter: `require("nvim-treesitter").install({...})` + `vim.treesitter.start()` を使用。旧 `require("nvim-treesitter.configs").setup()` は廃止
- LSP: `vim.lsp.config()` + `vim.lsp.enable()` を使用。旧 `require("lspconfig").server.setup()` は非推奨
- 診断: `vim.diagnostic.*` を使用。旧 `vim.lsp.diagnostic.*` は廃止

## 対応言語

Go, Rust, TypeScript/JavaScript, Python, C, Dart/Flutter, Terraform

## Git コミット

- `Co-Authored-By` は付けない

## レガシー設定

- `dein-legacy/` — 移行前の dein + VimScript 設定（アーカイブ、編集不要）
