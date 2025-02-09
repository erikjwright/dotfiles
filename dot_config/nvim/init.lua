local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  -- vim.o.rtp:prepend(mini_path)

  add({
    source = "folke/tokyonight.nvim",
  })

  vim.cmd("colorscheme tokyonight-night")
  vim.cmd("filetype plugin indent on")

  vim.g.mapleader = " "

  vim.o.termguicolors = true
  -- vim.o.conceallevel = 2
  -- vim.o.list = true
  vim.o.guicursor = "n-v-c-i:block-blinkwait1000-blinkon500-blinkoff500"
  vim.o.signcolumn = "yes"
  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
  -- vim.o.listchars = "tab:❘-,trail:·,extends:»,precedes:«,nbsp:×"
  vim.o.number = true
  vim.o.relativenumber = true

  -- Create `<Leader>` mappings
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

  -- e is for 'explore' and 'edit'
  nmap_leader("ed", "<Cmd>lua MiniFiles.open()<CR>", "Directory")
  nmap_leader("ef", "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", "File directory")
  nmap_leader("eq", "<Cmd>lua Config.toggle_quickfix()<CR>", "Quickfix")

  -- f is for 'fuzzy find'
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
  nmap_leader("fv", '<Cmd>Pick visit_paths cwd=""<CR>', "Visit paths (all)")
  nmap_leader("fV", "<Cmd>Pick visit_paths<CR>", "Visit paths (cwd)")

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", {}),
    desc = "Hightlight selection on yank",
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 180 })
    end,
  })
end)
now(function()
  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()
end)
now(function()
  require("mini.icons").setup()
end)
now(function()
  require("mini.statusline").setup()
end)

later(function()
  local MiniExtra = require("mini.extra")
  local MiniPick = require("mini.pick")

  MiniExtra.setup()
  MiniPick.setup({ window = { config = { border = "single" } } })

  vim.ui.select = MiniPick.ui_select

  -- MiniPick.registry.projects = function()
  --   local cwd = vim.fn.expand("~/repos")
  --   local choose = function(item)
  --     vim.schedule(function()
  --       MiniPick.builtin.files(nil, { source = { cwd = item.path } })
  --     end)
  --   end
  --   return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  -- end
end)
later(function()
  local MiniFiles = require("mini.files")
  MiniFiles.setup({ windows = { preview = true } })

  local minifiles_augroup = vim.api.nvim_create_augroup("ec-mini-files", {})

  vim.api.nvim_create_autocmd("User", {
    group = minifiles_augroup,
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      vim.api.nvim_win_set_config(args.data.win_id, { border = "single" })
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    group = minifiles_augroup,
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      ---@diagnostic disable-next-line
      MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      MiniFiles.set_bookmark("m", vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim", { desc = "mini.nvim" })
      MiniFiles.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/deps/opt", { desc = "Plugins" })
      MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end,
  })
end)

-- later(function()
--   require('mini.diff').setup()
--   local rhs = function() return MiniDiff.operator('yank') .. 'gh' end
--   vim.keymap.set('n', 'ghy', rhs, { expr = true, remap = true, desc = "Copy hunk's reference lines" })
-- end)

-- later(function()
--   require("mini.comment").setup()
-- end)

-- later(function()
--   local miniclue = require('mini.clue')
--   --stylua: ignore
--   miniclue.setup({
--     clues = {
--       Config.leader_group_clues,
--       miniclue.gen_clues.builtin_completion(),
--       miniclue.gen_clues.g(),
--       miniclue.gen_clues.marks(),
--       miniclue.gen_clues.registers(),
--       miniclue.gen_clues.windows({ submode_resize = true }),
--       miniclue.gen_clues.z(),
--     },
--     triggers = {
--       { mode = 'n', keys = '<Leader>' }, -- Leader triggers
--       { mode = 'x', keys = '<Leader>' },
--       { mode = 'n', keys = [[\]] },      -- mini.basics
--       { mode = 'n', keys = '[' },        -- mini.bracketed
--       { mode = 'n', keys = ']' },
--       { mode = 'x', keys = '[' },
--       { mode = 'x', keys = ']' },
--       { mode = 'i', keys = '<C-x>' },    -- Built-in completion
--       { mode = 'n', keys = 'g' },        -- `g` key
--       { mode = 'x', keys = 'g' },
--       { mode = 'n', keys = "'" },        -- Marks
--       { mode = 'n', keys = '`' },
--       { mode = 'x', keys = "'" },
--       { mode = 'x', keys = '`' },
--       { mode = 'n', keys = '"' },        -- Registers
--       { mode = 'x', keys = '"' },
--       { mode = 'i', keys = '<C-r>' },
--       { mode = 'c', keys = '<C-r>' },
--       { mode = 'n', keys = '<C-w>' },    -- Window commands
--       { mode = 'n', keys = 'z' },        -- `z` key
--       { mode = 'x', keys = 'z' },
--     },
--     window = { config = { border = 'double' } },
--   })
-- end)
-- later(function() require('mini.ai').setup() end)
-- later(function() require('mini.surround').setup() end)

now(function()
  add({
    source = "folke/lazydev.nvim",
  })
  add({
    source = "saghen/blink.cmp",
    depends = {
      "rafamadriz/friendly-snippets",
    },
    checkout = "0.11.0",
  })
  add({
    source = "WhoIsSethDaniel/mason-tool-installer.nvim",
    depends = { "williamboman/mason.nvim" },
  })
  add({
    source = "saghen/blink.cmp",
    depends = {
      "williamboman/mason.nvim",
    },
  })

  ---@diagnostic disable-next-line: missing-fields
  require("mason").setup()
  require("mason-tool-installer").setup({
    ensure_installed = {
		-- "codelldb",
		--     "debugpy",
      -- "lua-language-server",
      -- "pylyzer",
      -- "stylua",
      -- "taplo",
      -- "typescript-language-server",
    },
  })

  vim.lsp.config["luals"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          -- "nvim-dap-ui",
        },
        runtime = {
          version = "LuaJIT",
        },
      },
    },
  }

  vim.lsp.enable("luals")

  vim.lsp.config["pylyzer"] = {
    cmd = { "pylyzer" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml" },
  }

  vim.lsp.enable("pylyzer")

  --
  -- vim.lsp.config["ruff"] = {
  --   -- on_attach = function(client)
  --   --   client.server_capabilities.hoverProvider = false
  --   -- end,
  --   cmd = { "ruff" },
  --   filetypes = { "python" },
  --   root_markers = { "pyproject.toml" },
  -- }
  --
  -- vim.lsp.enable("ruff")

  add({
    source = "pmizio/typescript-tools.nvim",
    depends = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  })

  require("typescript-tools").setup({
    settings = {
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  })

  add({
    source =   'mrcjkb/rustaceanvim',
  })

  -- require("typescript-tools").setup({
  --   settings = {
  --     jsx_close_tag = {
  --       enable = true,
  --       filetypes = { "javascriptreact", "typescriptreact" },
  --     },
  --   },
  -- })

end)

later(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    monitor = "main",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "markdown" },
    highlight = { enable = true },
  })

  add({
    source = "olimorris/codecompanion.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  })

  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
      },
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ",
        provider = "mini_pick",
        os = {
          show_default_actions = true,
          show_default_prompt_library = true,
        },
      },
    },
  })

  add({
    source = "stevearc/conform.nvim",
  })

  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      -- Conform will run multiple formatters sequentially
      -- python = { "isort", "black" },
      -- You can customize some of the format oions for the filetype (:help conform.format)
      -- rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      lsp_format = "fallback",
    },
  })
end)
later(function()
  add({ source = "akinsho/toggleterm.nvim" })

  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
      border = "single",
      winblend = 3,
    },
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end,
    },
    responsiveness = {
      -- breakpoint in terms of `vim.o.columns` at which terminals will start to stack on top of each other
      -- instead of next to each other
      -- default = 0 which means the feature is turned off
      horizontal_breakpoint = 135,
    },
  })
end)
