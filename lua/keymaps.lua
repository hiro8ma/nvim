local map = vim.keymap.set

-- jj で ESC
map("i", "jj", "<ESC>", { silent = true })

-- ESC 2回でハイライト解除
map("n", "<Esc><Esc>", ":nohl<CR>", { silent = true })

-- インサートモードで C-j で ESC
map("i", "<C-j>", "<Esc>")

-- 検索時の / ? エスケープ
map("c", "/", function()
  return vim.fn.getcmdtype() == "/" and "\\/" or "/"
end, { expr = true })
map("c", "?", function()
  return vim.fn.getcmdtype() == "?" and "\\?" or "?"
end, { expr = true })

-- 表示行移動
map("n", "k", "gk")
map("n", "j", "gj")

-- & でフラグ維持置換
map("n", "&", ":&&<CR>")

-- ; と : の入れ替え
map("n", ";", ":", { silent = true })
map("n", ":", ";", { silent = true })

-- バッファ操作
map("n", "[B", ":bfirst<CR>", { silent = true })
map("n", "]B", ":blast<CR>", { silent = true })
map("n", "bv", ":bprevious<CR>", { silent = true })
map("n", "bn", ":bnext<CR>", { silent = true })
map("n", "bd", ":bdelete<CR>", { silent = true })

-- 検索結果を中央に
map("n", "<Leader>n", "nzz")
map("n", "<Leader>N", "Nzz")

-- ウィンドウ操作
map("n", "sr", "<C-w>r")
map("n", "sw", "<C-w>w")
map("n", "ss", ":<C-u>sp<CR>")
map("n", "sv", ":<C-u>vs<CR>")
map("n", "sq", ":<C-u>q<CR>")

-- ビジュアルモード
map("v", "v", "$h")

-- ビジュアルモードで * # 検索
map("x", "&", ":&&<CR>")
