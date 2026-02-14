# Neovim 設定 — Claude Code プロジェクト規約

このリポジトリは Neovim の設定ファイル。変更時は以下の規約と最新情報に従うこと。

## アーキテクチャ

```
init.lua                    -- require のみ
lua/
  options.lua               -- vim.opt 設定
  keymaps.lua               -- vim.keymap.set
  autocmds.lua              -- nvim_create_autocmd
  plugins/
    init.lua                -- lazy.nvim ブートストラップ + プラグイン一覧
    <plugin>.lua            -- 1プラグイン1ファイル（lazy.nvim スペックを return）
colors/hybrid.vim           -- カラースキーム
snippets/rust.snip          -- スニペット
dein-legacy/                -- 旧設定アーカイブ（編集不要）
```

## 規約

### プラグイン追加手順
1. `lua/plugins/<name>.lua` を作成し、lazy.nvim スペックを `return` する
2. `lua/plugins/init.lua` の `require("lazy").setup({})` 内に `require("plugins.<name>")` を追加
3. `config` より `opts` を優先（lazy.nvim が自動で `setup(opts)` を呼ぶ）

```lua
-- opts パターン（推奨）
return {
  "author/plugin-name",
  opts = { option = "value" },
}

-- config パターン（カスタムロジックが必要な場合のみ）
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
    -- 追加ロジック
  end,
}
```

### 遅延読み込み
| トリガー | 用途 | 例 |
|---------|------|-----|
| `event` | イベント発火時 | `event = "BufReadPre"`, `event = "VeryLazy"` |
| `ft` | ファイルタイプ | `ft = { "go", "rust" }` |
| `cmd` | コマンド実行時 | `cmd = "Telescope"` |
| `keys` | キーマップ | `keys = { { "<leader>e", ... } }` |

### LSP サーバー追加手順
- `lua/plugins/lsp.lua` の `vim.lsp.enable({})` リストにサーバー名を追加
- `vim.lsp.config()` / `vim.lsp.enable()` を使用（`require("lspconfig").setup()` は非推奨）
- キーマップは `LspAttach` autocmd 内で設定（`on_attach` はマージされないため非推奨）

### フォーマッタ追加手順
- `lua/plugins/conform.lua` の `formatters_by_ft` に追加
- 個別のフォーマッタプラグインは追加しない（conform.nvim で統合）

### キーマッピング
- グローバルなキーマップ → `lua/keymaps.lua`
- LSP キーマップ → `lua/plugins/lsp.lua` の `LspAttach` autocmd 内
- プラグイン固有 → 各プラグインファイルの `config` 内か `keys` スペック

### オプション設定
- `vim.opt.*` → `lua/options.lua`
- autocommand → `lua/autocmds.lua`

## Neovim 0.11+ API リファレンス

### LSP
```lua
-- グローバル設定
vim.lsp.config("*", { capabilities = ..., root_markers = { ".git" } })
-- サーバー個別設定
vim.lsp.config("gopls", { settings = { ... } })
-- 有効化
vim.lsp.enable({ "gopls", "rust_analyzer", "ts_ls" })
```
- `require("lspconfig")` は非推奨。nvim-lspconfig はデフォルト設定の提供元として残る
- `lsp/` ディレクトリ（`lua/` の外、`init.lua` と同階層）に置くと自動検出される
- `on_attach` は `LspAttach` autocmd で代替

### Treesitter
```lua
-- パーサーインストール（nvim-treesitter プラグイン）
require("nvim-treesitter").install({ "go", "rust", "lua" })
-- ハイライト有効化（Neovim 組み込み）
vim.treesitter.start(bufnr)
```
- 旧 `require("nvim-treesitter.configs").setup()` は完全廃止
- ハイライト・フォールディングは Neovim 組み込み
- インデントは nvim-treesitter プラグイン提供（実験的）

### 診断
```lua
vim.diagnostic.config({
  virtual_text = { current_line = true },  -- カーソル行のみ表示
  virtual_lines = false,                   -- 組み込み virtual_lines（lsp_lines.nvim 不要）
})
```
- `vim.lsp.diagnostic.*` は廃止 → `vim.diagnostic.*` を使用
- virtual_text は 0.11 でデフォルト OFF

### 組み込みデフォルトキーマップ（設定不要）
| キー | 機能 |
|------|------|
| `grn` | `vim.lsp.buf.rename()` |
| `grr` | `vim.lsp.buf.references()` |
| `gri` | `vim.lsp.buf.implementation()` |
| `gra` | `vim.lsp.buf.code_action()` |
| `gO` | `vim.lsp.buf.document_symbol()` |
| `<C-S>` | `vim.lsp.buf.signature_help()`（Insert モード） |
| `[d` / `]d` | 診断ジャンプ |
| `gc` / `gcc` | コメントトグル（vim-commentary 不要） |

### 不要になったプラグイン
| 旧プラグイン | 組み込み代替 |
|-------------|-------------|
| vim-commentary / Comment.nvim | `gc` / `gcc` |
| lsp_lines.nvim | `vim.diagnostic.config({ virtual_lines = true })` |
| lsp_signature.nvim | `<C-S>` デフォルトマップ |
| vim-unimpaired（一部） | `[d` / `]d` 等 |

## 推奨プラグインスタック（2025-2026）

### Tier 1: コア
| カテゴリ | 推奨 | 備考 |
|---------|------|------|
| プラグイン管理 | **lazy.nvim** | 標準。0.12 で `vim.pack` 組み込み予定 |
| 補完 | **blink.cmp** | nvim-cmp より高速。fuzzy + typo 耐性。組み込みソース |
| フォーマット | **conform.nvim** | format-on-save 統合 |
| リント | **nvim-lint** | conform と併用 |
| 構文解析 | **nvim-treesitter** | パーサー管理 + textobjects |

### Tier 2: ワークフロー
| カテゴリ | 推奨 | 備考 |
|---------|------|------|
| ファジーファインダー | **snacks.picker** or telescope | snacks.picker が LazyVim 新デフォルト |
| ファイラー | **oil.nvim** + neo-tree | oil = バッファ操作、neo-tree = サイドバー |
| Git 行表示 | **gitsigns.nvim** | 必須 |
| Git 操作 | **lazygit** (snacks.lazygit) | fugitive から移行推奨 |
| ステータスライン | **lualine.nvim** | 定番 |
| キーマップ発見 | **which-key.nvim** | 必須 |
| 診断パネル | **trouble.nvim** v3 | |
| モーション | **flash.nvim** | f/F/t/T 強化 |

### Tier 3: 多機能統合
| カテゴリ | 推奨 | 備考 |
|---------|------|------|
| QoL 統合 | **snacks.nvim** | 30+ モジュール。picker, explorer, notifier, indent, terminal 等 |
| UI | **noice.nvim** | cmdline/messages 置換 |

### Tier 4: AI
| カテゴリ | 推奨 | 備考 |
|---------|------|------|
| ゴーストテキスト | **copilot.lua** | copilot.vim の Lua 版 |
| AI チャット | **avante.nvim** or **codecompanion.nvim** | Claude/GPT/Gemini 対応 |
| Claude Code 連携 | **claude-code.nvim** | |

### 言語別
| 言語 | 推奨 | 備考 |
|------|------|------|
| Go | **gopls** (純 LSP) | vim-go はレガシー |
| Rust | **rustaceanvim** | rust.vim / rust-tools.nvim はアーカイブ |
| TypeScript | **vtsls** | ts_ls より LSP 準拠。LazyVim デフォルト |

## 現在の設定で検討すべき改善

以下は現在インストール済みだが、より良い代替がある項目:

| 現在 | 推奨変更 | 理由 |
|------|---------|------|
| nvim-cmp | blink.cmp | 高速、ビルトインソース、設定簡潔 |
| vim-commentary | 削除 | Neovim 0.11 で `gc`/`gcc` 組み込み |
| copilot.vim | copilot.lua | Lua ネイティブ、blink.cmp 統合可 |
| telescope.nvim | snacks.picker | LazyVim 新デフォルト、高速 |
| rust.vim | rustaceanvim | アーカイブ済み→後継 |
| vim-go | 削除（gopls で十分） | レガシー |
| neosnippet.vim | 削除（vim.snippet 組み込み） | Neovim 0.11 で組み込み |
| vim-vsnip | 削除 | blink.cmp が組み込みスニペット対応 |

## Git コミット

- `Co-Authored-By` は付けない

## 対応言語

Go, Rust, TypeScript/JavaScript, Python, C, Dart/Flutter, Terraform
