vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {}),
  desc = "Highlight yanked text",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinNew", "VimResized" }, {
  group = vim.api.nvim_create_augroup("VCenterCursor", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 2)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
  pattern = { "*" },
  callback = function()
    vim.opt_local.fo:remove("c")
    vim.opt_local.fo:remove("r")
    vim.opt_local.fo:remove("o")
  end,
})
