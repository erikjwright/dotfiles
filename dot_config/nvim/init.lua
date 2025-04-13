local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- TODO: Add `:%y+`

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.guicursor = "n-v-c-i:block-blinkwait1000-blinkon500-blinkoff500"
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 999

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
-- vim.o.listchars = "tab:❘-,trail:·,extends:»,precedes:«,nbsp:×"
vim.opt.listchars:append({
  -- tab = "·",
  tab = "❘-",
  trail = "￮",
  extends = "▶",
  precedes = "◀",
  nbsp = "⏑",
})
vim.opt.updatetime = 100
vim.opt.timeoutlen = 500

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 60 }) end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
  pattern = "*",
  callback = function() vim.opt.formatoptions = "cqrnj" end,
})

vim.keymap.set(
  "n",
  "<leader>xe",
  function() vim.diagnostic.open_float({ focusable = true }) end,
  { desc = "Expand Error into float" }
)

-- local opts = { noremap = true, silent = false }
--
-- -- Create a new note after asking for its title.
-- vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
--
-- -- Open notes.
-- vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- -- Open notes associated with the selected tags.
-- vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
--
-- -- Search for the notes matching a given query.
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>zf",
--   "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
--   opts
-- )
-- -- Search for the notes matching the current visual selection.
-- vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", opts)

vim.g.augment_workspace_folders = { vim.uv.cwd() }

vim.lsp.config["astro"] = {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json" },
  init_options = {
    typescript = {
      tsdk = vim.uv.cwd() .. "/node_modules/typescript/lib",
    },
  },
}

vim.lsp.enable("astro")

vim.lsp.config["go"] = {
  cmd = { "gopls" },
  filetypes = { "go" },
  root_markers = { "go.mod" },
}

vim.lsp.enable("go")

vim.lsp.config["luals"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          vim.fn.stdpath("data") .. "/lazy",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

vim.lsp.enable("luals")

vim.lsp.config["rust"] = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml" },
  on_attach = function(client) client.server_capabilities.semanticTokensProvider = nil end,
}

vim.lsp.enable("rust")

vim.lsp.config["tailwindcss"] = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json" },
}

vim.lsp.enable("tailwindcss")

vim.lsp.config["tsserver"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json" },
}

vim.lsp.enable("tsserver")

vim.diagnostic.config({ virtual_text = false })

-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()

require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function() vim.cmd([[colorscheme tokyonight-night]]) end,
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        -- bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = {
          enabled = true,
        },
        git = { enabled = true },
        indent = {
          enabled = true,
          animate = {
            enabled = false,
          },
        },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
          top_down = false,
          margin = { bottom = 1 },
        },
        picker = { enabled = true },
        -- quickfile = { enabled = true },
        -- scope = { enabled = true },
        -- scroll = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- terminal = { enabled = true },
        words = { enabled = true },
        -- styles = {
        --   notification = {
        --     wo = { wrap = true }, -- Wrap notifications
        --   },
        -- },
      },
      keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>f/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fh", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
        {
          "<leader>fc",
          function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
          desc = "Find Config File",
        },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        {
          "<leader>sw",
          function() Snacks.picker.grep_word() end,
          desc = "Visual selection or word",
          mode = { "n", "x" },
        },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- lsp
        -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

        -- vim.api.nvim_create_autocmd("LspAttach", {
        --   callback = function(args)
        --     -- local opts = { noremap = true, silent = true }
        --
        --     local bufmap = function(mode, lhs, rhs, desc)
        --       local opts = { buffer = args.buf, desc = desc }
        --       vim.keymap.set(mode, lhs, rhs, opts)
        --     end
        --
        --     bufmap("i", "<c-leader>", "<C-x><C-o>", "Open Cmp/Definition")
        --     bufmap("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration")
        --     bufmap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition")
        --     bufmap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover")
        --     bufmap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action")
        --     bufmap("v", "<leader>la", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Range Code Action")
        --     bufmap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation")
        --     bufmap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help")
        --     bufmap("n", "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename")
        --     bufmap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", "References")
        --     bufmap("n", "<leader>lo", "<cmd>lua vim.diagnostic.open_float()<cr>", "Open Diagnostic")
        --   end,
        -- })
        --   -- Other
        --   { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        --   { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        --   { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        --   { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        --   { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        --   { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        --   { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        --   { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        --   { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      },
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      opts = {
        -- lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        --   override = {
        --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --     ["vim.lsp.util.stylize_markdown"] = true,
        --     ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        --   },
        -- },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = {
        "ravitemer/mcphub.nvim",
      },
      opts = {
        options = {
          component_separators = "",
          section_separators = "",
        },
        -- sections = {
        --   lualine_x = {
        --     { require("mcphub.extensions.lualine") },
        --   },
        -- },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        ---@diagnostic disable-next-line: missing-fields
        configs.setup({
          ensure_installed = {
            "astro",
            "bash",
            "c",
            "comment",
            "cmake",
            "css",
            "csv",
            "diff",
            "dockerfile",
            "editorconfig",
            -- "elixir",
            "graphql",
            -- "heex",
            "html",
            "javascript",
            "jq",
            "json",
            -- "latex",
            "lua",
            "markdown",
            "markdown_inline",
            "nix",
            -- "norg",
            "prisma",
            "query",
            "regex",
            "rust",
            "sql",
            "ssh_config",
            "toml",
            "tsx",
            "typescript",
            -- "typst",
            "vim",
            "vimdoc",
            "yaml",
            "zig",
          },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { markdown },
          },
        })
      end,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = function(_, opts)
        opts.enable_autocmd = false

        vim.filetype.get_option = function(filetype, option)
          return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
            or vim.filetype.get_option(filetype, option)
        end
      end,
    },
    {
      "RaafatTurki/corn.nvim",
      opts = {
        vim.keymap.set("n", "<leader>xx", "<cmd>Corn toggle<cr>", { desc = "Diagnostics" }),
        -- :Corn scope <file|line>
        -- :Corn scope_cycle
        -- :Corn render
        on_toggle = function(is_hidden)
          vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
        end,
        item_preprocess_func = function(item) return item end,
      },
    },
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {},
    },
    ---@type LazySpec
    {
      "mikavilpas/yazi.nvim",
      dependencies = { "folke/snacks.nvim" },
      event = "VeryLazy",
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>e",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Open in the current working directory
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      ---@type YaziConfig
      opts = {
        open_for_directories = true,
        keymaps = {
          show_help = "<f1>",
        },
        integrations = {
          grep_in_directory = function(directory) Snacks.picker.grep({ cwd = directory }) end,
        },
      },
    },

    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        delay = 1000,
      },
      keys = {
        {
          "<leader>?",
          function() require("which-key").show({ global = false }) end,
          desc = "Buffer Local Keymaps",
        },
      },
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      opts = {
        formatters_by_ft = {
          astro = { "biome", "prettierd", "prettier" },
          css = { "biome", "tailwindcss" },
          go = { "gofmt" },
          lua = { "stylua" },
          javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "biome" },
          json = { "biome" },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
          typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "biome" },
        },
        format_on_save = { timeout_ms = 500 },
        lsp_format = "fallback",
      },
      -- init = function()
      --   vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- end,
    },
    {
      "saghen/blink.cmp",
      dependencies = { "rafamadriz/friendly-snippets" },
      version = "1.*",
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = "default" },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = { auto_show = false },
          ghost_text = { enabled = true },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = { enabled = true },
      },
      -- opts_extend = { "sources.default" },
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        open_mapping = [[<c-\>]],
        direction = "float",
      },
    },
    {
      "numToStr/Comment.nvim",
      opts = {},
    },
    {
      "ravitemer/mcphub.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = {
        config = vim.uv.cwd() .. "/mcp.json",
        on_ready = function() vim.notify("MCP Hub is online!") end,
        log = {
          level = vim.log.levels.WARN,
          to_file = true,
        },
      },
    },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      keys = {
        { "<leader>cc", "<cmd>CodeCompanionChat toggle<cr>", desc = "Code Companion Chat" },
        { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions" },
      },
      opts = {
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-pro-exp-03-25",
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "anthropic",
            tools = {
              ["mcp"] = {
                callback = function() return require("mcphub.extensions.codecompanion") end,
                description = "Call tools and resources from the MCP Servers",
                opts = {
                  requires_approval = true,
                },
              },
            },
          },
          inline = {
            adapter = "anthropic",
            tools = {
              ["mcp"] = {
                callback = function() return require("mcphub.extensions.codecompanion") end,
                description = "Call tools and resources from the MCP Servers",
                opts = {
                  requires_approval = true,
                },
              },
            },
          },
          cmd = {
            adapter = "anthropic",
            tools = {
              ["mcp"] = {
                callback = function() return require("mcphub.extensions.codecompanion") end,
                description = "Call tools and resources from the MCP Servers",
                opts = {
                  requires_approval = true,
                },
              },
            },
          },
        },
        display = {
          chat = {
            show_settings = true,
          },
        },
      },
    },
    -- {
    --   "MeanderingProgrammer/render-markdown.nvim",
    --   ft = {
    --     -- "codecompanion",
    --     "markdown",
    --   },
    --   opts = {
    --     completions = { blink = { enabled = true }, lsp = { enabled = true } },
    --     heading = {
    --       enabled = false,
    --     },
    --     latex = { enabled = false },
    --     render_modes = true,
    --     sign = {
    --       enabled = false,
    --     },
    --   },
    -- },
    install = { colorscheme = { "tokyonight" } },
    checker = { enabled = true },
  },
})
