vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

local clues = {
    { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
    { mode = "n", keys = "<Leader>e", desc = "+Explore" },
    { mode = "n", keys = "<Leader>f", desc = "+Find" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>l", desc = "+LSP" },
    { mode = "n", keys = "<Leader>L", desc = "+Lua" },
    { mode = "n", keys = "<Leader>m", desc = "+Map" },
    { mode = "n", keys = "<Leader>o", desc = "+Other" },
    { mode = "n", keys = "<Leader>r", desc = "+R" },
    { mode = "n", keys = "<Leader>t", desc = "+Terminal/Minitest" },
    { mode = "n", keys = "<Leader>T", desc = "+Test" },
    { mode = "n", keys = "<Leader>v", desc = "+Visits" },

    { mode = "x", keys = "<Leader>l", desc = "+LSP" },
    { mode = "x", keys = "<Leader>r", desc = "+R" },
}

local nmap_leader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set("n", "<Leader>" .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set("x", "<Leader>" .. suffix, rhs, opts)
end

-- edit/explore
nmap_leader("ed", "<Cmd>lua MiniFiles.open()<CR>", "Directory")
nmap_leader("ef", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", "File directory")
nmap_leader("ei", "<Cmd>edit $MYVIMRC<CR>", "File directory")
nmap_leader("eq", "<Cmd>lua Config.toggle_quickfix()<CR>", "Quickfix")

-- fuzzy
nmap_leader("f/", '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader("f:", '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader("fa", '<Cmd>Pick git_hunks scope="staged"<CR>', "Added hunks (all)")
nmap_leader("fA", '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', "Added hunks (current)")
nmap_leader("fb", "<Cmd>Pick buffers<CR>", "Buffers")
nmap_leader("fc", "<Cmd>Pick git_commits<CR>", "Commits (all)")
nmap_leader("fC", '<Cmd>Pick git_commits path="%"<CR>', "Commits (current)")
nmap_leader("fd", '<Cmd>Pick diagnostic scope="all"<CR>', "Diagnostic workspace")
nmap_leader("fD", '<Cmd>Pick diagnostic scope="current"<CR>', "Diagnostic buffer")
nmap_leader("ff", "<Cmd>Pick files<CR>", "Files")
nmap_leader("fg", "<Cmd>Pick grep_live<CR>", "Grep live")
nmap_leader("fG", '<Cmd>Pick grep pattern="<cword>"<CR>', "Grep current word")
nmap_leader("fh", "<Cmd>Pick help<CR>", "Help tags")
nmap_leader("fH", "<Cmd>Pick hl_groups<CR>", "Highlight groups")
nmap_leader("fl", '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all)")
nmap_leader("fL", '<Cmd>Pick buf_lines scope="current"<CR>', "Lines (current)")
nmap_leader("fm", "<Cmd>Pick git_hunks<CR>", "Modified hunks (all)")
nmap_leader("fM", '<Cmd>Pick git_hunks path="%"<CR>', "Modified hunks (current)")
nmap_leader("fr", "<Cmd>Pick resume<CR>", "Resume")
nmap_leader("fp", "<Cmd>Pick projects<CR>", "Projects")
nmap_leader("fR", '<Cmd>Pick lsp scope="references"<CR>', "References (LSP)")
nmap_leader("fs", '<Cmd>Pick lsp scope="workspace_symbol"<CR>', "Symbols workspace (LSP)")
nmap_leader("fS", '<Cmd>Pick lsp scope="document_symbol"<CR>', "Symbols buffer (LSP)")
nmap_leader("fv", '<Cmd>Pick visit_paths cwd="" preserve_order=true<CR>', "Visit paths (all)")
nmap_leader("fV", "<Cmd>Pick visit_paths preserve_order=true<CR>", "Visit paths (cwd)")

-- git
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]

nmap_leader("ga", "<Cmd>Git diff --cached<CR>", "Added diff")
nmap_leader("gA", "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer")
nmap_leader("gc", "<Cmd>Git commit<CR>", "Commit")
nmap_leader("gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
nmap_leader("gd", "<Cmd>Git diff<CR>", "Diff")
nmap_leader("gD", "<Cmd>Git diff -- %<CR>", "Diff buffer")
-- nmap_leader("gg", "<Cmd>lua Config.open_lazygit()<CR>", "Git tab")
nmap_leader("gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log")
nmap_leader("gL", "<Cmd>" .. git_log_cmd .. " --follow -- %<CR>", "Log buffer")
nmap_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
nmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor")

xmap_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

-- lsp
local formatting_cmd = '<Cmd>lua require("conform").format({ lsp_fallback = true })<CR>'

nmap_leader("la", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Arguments popup")
nmap_leader("ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostics popup")
nmap_leader("lf", formatting_cmd, "Format")
nmap_leader("li", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Information")
nmap_leader("lj", "<Cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic")
nmap_leader("lk", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev diagnostic")
nmap_leader("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
nmap_leader("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
nmap_leader("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")

xmap_leader("lf", formatting_cmd, "Format selection")

-- Test
nmap_leader("ta", "<Cmd>lua MiniTest.run()<CR>", "Test run all")
nmap_leader("tf", "<Cmd>lua MiniTest.run_file()<CR>", "Test run file")
nmap_leader("tl", "<Cmd>lua MiniTest.run_at_location()<CR>", "Test run location")
nmap_leader("ts", "<Cmd>lua Config.minitest_screenshots.browse()<CR>", "Test show screenshot")
nmap_leader("tT", "<Cmd>belowright Tnew<CR>", "Terminal (horizontal)")
nmap_leader("tt", "<Cmd>vertical Tnew<CR>", "Terminal (vertical)")
nmap_leader("TF", "<Cmd>TestFile -strategy=make | copen<CR>", "File (quickfix)")
nmap_leader("Tf", "<Cmd>TestFile<CR>", "File")
nmap_leader("TL", "<Cmd>TestLast -strategy=make | copen<CR>", "Last (quickfix)")
nmap_leader("Tl", "<Cmd>TestLast<CR>", "Last")
nmap_leader("TN", "<Cmd>TestNearest -strategy=make | copen<CR>", "Nearest (quickfix)")
nmap_leader("Tn", "<Cmd>TestNearest<CR>", "Nearest")
nmap_leader("TS", "<Cmd>TestSuite -strategy=make | copen<CR>", "Suite (quickfix)")
nmap_leader("Ts", "<Cmd>TestSuite<CR>", "Suite")
