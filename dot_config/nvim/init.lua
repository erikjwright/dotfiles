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

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.guicursor = "n-v-c-i:block-blinkwait1000-blinkon500-blinkoff500"
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 999

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
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

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 60 })
  end,
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
      runtime = {
        version = "LuaJIT",
      },
    },
  },
}

vim.lsp.enable("luals")

vim.lsp.config["pyright"] = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
  capabilities = {
    general = {
      positionEncodings = { "utf-16" },
    },
  },
}

vim.lsp.enable("pyright")

require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },
    {
      "echasnovski/mini.nvim",
      version = "*",
      config = function()
        require("mini.icons").setup()
        require("mini.statusline").setup()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = {
            "bash",
            "c",
            "elixir",
            "heex",
            "html",
            "javascript",
            "lua",
            "markdown",
            "markdown_inline",
            "nix",
            "python",
            "query",
            "regex",
            "typescript",
            "tsx",
            "vim",
            "vimdoc",
          },
          auto_install = false,
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        })
      end,
    },
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          python = { "ruff" },
          -- rust = { "rustfmt", lsp_format = "fallback" },
          -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        format_on_save = {
          lsp_format = "fallback",
        },
      },
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
    },
    {
      "luckasRanarison/tailwind-tools.nvim",
      name = "tailwind-tools",
      build = ":UpdateRemotePlugins",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {}, -- your configuration
    },
    { "github/copilot.vim" },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
        --   display = {
        --     action_palette = {
        --       width = 95,
        --       height = 10,
        --       prompt = "Prompt ",
        --       provider = "mini_pick",
        --       os = {
        --         show_default_actions = true,
        --         show_default_prompt_library = true,
        --       },
        --     },
        --   },
      },
    },
    {
      "saghen/blink.cmp",
      version = "*",
      dependencies = { "olimorris/codecompanion.nvim" },
      opts = {
        sources = {
          default = { "codecompanion", "lazydev", "lsp", "path", "snippets", "buffer" },
          providers = {
            codecompanion = {
              name = "CodeCompanion",
              module = "codecompanion.providers.completion.blink",
              enabled = true,
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
          },
        },
      },
    },
    {
      "folke/snacks.nvim",
      ---@type snacks.Config
      opts = {
        picker = {
          -- your picker configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        },
      },
      keys = {
        -- Top Pickers & Explorer
        {
          "<leader><space>",
          function()
            Snacks.picker.smart()
          end,
          desc = "Smart Find Files",
        },
        {
          "<leader>,",
          function()
            Snacks.picker.buffers()
          end,
          desc = "Buffers",
        },
        {
          "<leader>/",
          function()
            Snacks.picker.grep()
          end,
          desc = "Grep",
        },
        {
          "<leader>:",
          function()
            Snacks.picker.command_history()
          end,
          desc = "Command History",
        },
        {
          "<leader>n",
          function()
            Snacks.picker.notifications()
          end,
          desc = "Notification History",
        },
      },
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
          grep_in_directory = function(directory)
            Snacks.picker.grep({ cwd = directory })
          end,
        },
      },
    },
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
      },
      keys = {
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
          desc = "Debug: Start/Continue",
        },
        {
          "<F1>",
          function()
            require("dap").step_into()
          end,
          desc = "Debug: Step Into",
        },
        {
          "<F2>",
          function()
            require("dap").step_over()
          end,
          desc = "Debug: Step Over",
        },
        {
          "<F3>",
          function()
            require("dap").step_out()
          end,
          desc = "Debug: Step Out",
        },
        {
          "<leader>b",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Debug: Toggle Breakpoint",
        },
        {
          "<leader>B",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Debug: Set Breakpoint",
        },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        {
          "<F7>",
          function()
            require("dapui").toggle()
          end,
          desc = "Debug: See last session result.",
        },
      },
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup({
          -- Set icons to characters that are more likely to work in every terminal.
          --    Feel free to remove or use ones that you like more! :)
          --    Don't feel like these are good choices.
          icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
          controls = {
            icons = {
              pause = "⏸",
              play = "▶",
              step_into = "⏎",
              step_over = "⏭",
              step_out = "⏮",
              step_back = "b",
              run_last = "▶▶",
              terminate = "⏹",
              disconnect = "⏏",
            },
          },
        })

        -- Change breakpoint icons
        -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
        -- local breakpoint_icons = vim.g.have_nerd_font
        --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
        -- for type, icon in pairs(breakpoint_icons) do
        --   local tp = 'Dap' .. type
        --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        -- end

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
      end,
    },
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
          python = { "ruff" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
          group = lint_augroup,
          callback = function()
            -- Only run the linter in buffers that you can modify in order to
            -- avoid superfluous noise, notably within the handy LSP pop-ups that
            -- describe the hovered symbol using Markdown.
            if vim.opt_local.modifiable:get() then
              lint.try_lint()
            end
          end,
        })
      end,
    },
    {
      "mfussenegger/nvim-dap-python",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require("dap-python").setup("uv")
        -- require('dap-python').test_runner = 'pytest'
      end,
    },
  },
  install = { colorscheme = { "tokyonight-night" } },
  checker = { enabled = true },
})
