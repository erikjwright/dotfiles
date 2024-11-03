local opt = vim.opt
local schedule = vim.schedule

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.textwidth = 0
opt.wrapmargin = 0
opt.wrap = true
opt.linebreak = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- opt.backspace = "indent,eol,start"

schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

opt.splitright = true
opt.splitbelow = true

opt.inccommand = 'split'
