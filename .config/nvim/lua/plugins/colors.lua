-- {
--   'catppuccin/nvim',
--   name = 'catppuccin',
--   priority = 1000,
--   init = function()
--     vim.cmd [[colorscheme catppuccin]]
--   end,
-- },
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
  init = function()
    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
