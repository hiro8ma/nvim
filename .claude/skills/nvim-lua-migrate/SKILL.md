---
name: nvim-lua-migrate
description: Neovim の設定を VimScript + dein から Lua + lazy.nvim にモダン移行する。init.vim の Lua 化、プラグインマネージャーの移行、非推奨 API の修正を行う。
disable-model-invocation: true
---

# Neovim VimScript → Lua 移行スキル

対象の Neovim 設定ディレクトリを Lua ベースのモダン構成に移行する。

## 移行対象

`$ARGUMENTS` が指定されていればそのパスを、未指定なら `~/.config/nvim` を対象とする。

## 手順

### 1. 現状分析

対象ディレクトリの構成を確認する:

- `init.vim` の内容（set, keymap, autocmd, プラグインマネージャー設定）
- プラグインマネージャーの種類（dein.toml, vim-plug の plug 文, packer 等）
- プラグイン一覧と各プラグインの設定
- LSP 設定の有無
- カラースキーム、スニペット等の付随ファイル

### 2. ディレクトリ構成の作成

以下の構成で `lua/` ディレクトリを作成:

```
init.lua                    -- require のみ
lua/
  options.lua               -- vim.opt 設定
  keymaps.lua               -- vim.keymap.set
  autocmds.lua              -- nvim_create_autocmd
  plugins/
    init.lua                -- lazy.nvim ブートストラップ + プラグイン一覧
    <plugin>.lua            -- 1プラグイン1ファイル
```

### 3. 設定の変換

#### options.lua
- `set xxx` → `vim.opt.xxx = value`
- `set noxxx` → `vim.opt.xxx = false`
- `let g:xxx` → `vim.g.xxx = value`
- Neovim 不要設定を削除: `nocompatible`, `t_Co`

#### keymaps.lua
- `nnoremap` → `vim.keymap.set("n", ...)`
- `inoremap` → `vim.keymap.set("i", ...)`
- `vnoremap` → `vim.keymap.set("v", ...)`
- `xnoremap` → `vim.keymap.set("x", ...)`
- `cnoremap` → `vim.keymap.set("c", ...)`
- `<expr>` マッピング → `{ expr = true }` オプション
- `<silent>` マッピング → `{ silent = true }` オプション

#### autocmds.lua
- `autocmd Event pattern command` → `vim.api.nvim_create_autocmd("Event", { pattern = "...", command/callback = ... })`
- `augroup` → `vim.api.nvim_create_augroup("name", { clear = true })`

### 4. プラグインマネージャーの移行

lazy.nvim のブートストラップを `lua/plugins/init.lua` に記述:

```lua
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
  require("plugins.xxx"),
  ...
})
```

各プラグインは `lua/plugins/<name>.lua` に lazy.nvim スペックを `return`:

```lua
return {
  "author/plugin-name",
  dependencies = {},
  ft = "xxx",           -- 遅延読み込み（任意）
  config = function()
    require("plugin").setup({})
  end,
}
```

### 5. プラグインのモダン化（ユーザーに確認の上）

| 旧 | 新候補 | 理由 |
|-----|--------|------|
| NERDTree | neo-tree.nvim | Lua 製、モダン UI |
| fzf.vim | telescope.nvim | Lua 製、LSP/treesitter 連携 |
| vim-airline | lualine.nvim | Lua 製、高速 |
| 個別フォーマッタ (vim-prettier 等) | conform.nvim | 統合管理 |

追加推奨プラグイン:
- **nvim-treesitter** — 構文解析ハイライト
- **gitsigns.nvim** — Git 変更行表示
- **which-key.nvim** — キーバインド発見
- **trouble.nvim** — 診断パネル

### 6. Neovim 0.11+ API 対応

#### LSP
```lua
-- 旧（非推奨）
require("lspconfig").server_name.setup({ on_attach = on_attach })

-- 新
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- キーマップ設定
  end,
})
vim.lsp.config("*", { capabilities = capabilities, root_markers = { ".git" } })
vim.lsp.enable({ "gopls", "rust_analyzer", ... })
```

#### Treesitter
```lua
-- 旧（廃止）
require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

-- 新
require("nvim-treesitter").install({ "lua", "go", ... })
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
```

#### 診断
- `vim.lsp.diagnostic.show_line_diagnostics()` → `vim.diagnostic.open_float()`
- `vim.lsp.diagnostic.goto_prev()` → `vim.diagnostic.goto_prev()`
- `vim.lsp.diagnostic.set_loclist()` → `vim.diagnostic.setloclist()`

#### LSP サーバー名
- `tsserver` → `ts_ls`

### 7. 旧ファイルの処理

- 旧設定を保存するブランチを作成（例: `dein-legacy`）
- 旧ファイル（`init.vim`, プラグインマネージャー設定ファイル）を削除
- `.gitignore` に `.netrwhist`, `.claude/` を追加

### 8. 環境変数の確認

`~/.zshrc` や `~/.bashrc` に `VIMINIT` が設定されている場合、コメントアウトする（Neovim は `~/.config/nvim/init.lua` を自動検出）。

### 9. 検証

- `nvim` を起動してエラーがないか確認
- `:checkhealth` を実行
- プラグインが正常にインストールされるか確認
- LSP, 補完, ファイラー, ファジーファインダーの動作確認
