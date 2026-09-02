return {
  "nvim-neotest/neotest",
  ft = { "go" },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          go_test_args = { "-v", "-race", "-count=1" },
        }),
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
    })

    local function map_go_buffer(buf)
      local opts = { buffer = buf, silent = true }
      vim.keymap.set("n", "tt", function() require("neotest").run.run() end,
        vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
      vim.keymap.set("n", "tf", function() require("neotest").run.run(vim.fn.expand("%")) end,
        vim.tbl_extend("force", opts, { desc = "Run file tests" }))
      vim.keymap.set("n", "tl", function() require("neotest").run.run_last() end,
        vim.tbl_extend("force", opts, { desc = "Run last test" }))
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function(ev) map_go_buffer(ev.buf) end,
    })
    -- 遅延読み込みのトリガーになった現在のバッファにも適用
    if vim.bo.filetype == "go" then map_go_buffer(0) end
  end,
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
    { "<leader>td", function() require("neotest").run.run({ suite = true }) end, desc = "Run test suite" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last test" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
    { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop test" },
  },
}
