local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 背景透過
augroup("ColorSchemeOverrides", { clear = true })
autocmd("ColorScheme", {
  group = "ColorSchemeOverrides",
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { ctermbg = "none" })
  end,
})

-- InsertLeave で nopaste
augroup("InsertLeaveNoPaste", { clear = true })
autocmd("InsertLeave", {
  group = "InsertLeaveNoPaste",
  pattern = "*",
  callback = function()
    vim.opt.paste = false
  end,
})
