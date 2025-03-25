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
local g = vim.g
local o = vim.opt
o.rtp:prepend(lazypath)

g.mapleader = " "
g.maplocalleader = "\\"

o.number = true
o.relativenumber = true
o.guicursor = "n-v-c-i:block-blinkwait1000-blinkon500-blinkoff500"
o.signcolumn = "yes"
o.scrolloff = 999
o.swapfile = false
o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.list = true
o.listchars = {
  tab = "❘-",
  trail = "￮",
  extends = "▶",
  precedes = "◀",
  nbsp = "⏑",
  -- eol = "$",
}

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 60 })
  end,
})

-- LSP configuration
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

vim.lsp.config["yaml"] = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  capabilities = {
    general = {
      positionEncodings = { "utf-16" },
    },
  },
}
vim.lsp.enable("yaml")

-- Plugin setup
require("lazy").setup({
  spec = {
    -- Theme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd([[colorscheme tokyonight-night]])
      end,
    },

    -- which-key.nvim for keymaps organization
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
        preset = "classic",
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
        },
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        layout = {
          width = { min = 20 },
          spacing = 3,
        },
        spec = {
          -- Top level groups
          { "<leader>f", group = "Find" },
          { "<leader>x", group = "Diagnostics" },
          { "<leader>c", group = "Code" },
          { "<leader>d", group = "Database" },

          -- Find operations
          {
            "<leader><space>",
            function()
              require("snacks").picker.smart()
            end,
            desc = "Smart Find Files",
          },
          {
            "<leader>,",
            function()
              require("snacks").picker.buffers()
            end,
            desc = "Buffers",
          },
          {
            "<leader>/",
            function()
              require("snacks").picker.grep()
            end,
            desc = "Grep",
          },
          {
            "<leader>:",
            function()
              require("snacks").picker.command_history()
            end,
            desc = "Command History",
          },

          -- Notifications
          {
            "<leader>n",
            function()
              require("snacks").picker.notifications()
            end,
            desc = "Notification History",
          },

          -- File explorer
          { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Yazi at current file" },

          -- Debug
          {
            "<leader>b",
            function()
              require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
          },
          {
            "<leader>B",
            function()
              require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Set Conditional Breakpoint",
          },

          -- Trouble diagnostics
          {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false<cr>",
            desc = "LSP Definitions/References (Trouble)",
          },

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
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
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
          --
          -- Code actions
          { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },

          { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open file manager in CWD" },

          -- Function keys
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
            "<F5>",
            function()
              require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
          },
          {
            "<F7>",
            function()
              require("dapui").toggle()
            end,
            desc = "Debug: Toggle UI",
          },

          -- Ctrl keys
          { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last Yazi session" },

          -- Database UI mappings
          { "<leader>du", "<cmd>DBUI<cr>", desc = "Open Database UI" },
          { "<leader>dt", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
          { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
          { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB Connection" },
          { "<leader>dr", "<cmd>DB<cr>", desc = "Run Query" },
        },
      },
    },
    --
    -- Mini plugins
    {
      "echasnovski/mini.nvim",
      version = "*",
      config = function()
        require("mini.icons").setup()
        require("mini.statusline").setup()
      end,
    },

    -- Treesitter
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
            "yaml",
          },
          auto_install = false,
          sync_install = false,
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        })
      end,
    },

    -- Trouble for diagnostics
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
    },

    -- nvim-notify configuration (add this to your lazy.nvim setup)
    {
      "rcarriga/nvim-notify",
      opts = {
        -- Position the notification window at the bottom right
        top_down = false, -- Notifications stack from bottom up instead of top down
        time_formats = {
          notification_history = "%Y-%m-%d %H:%M",
          notification = "%H:%M",
        },
        max_width = 50,
        max_height = 10,
        stages = "fade", -- Animation style ("fade", "slide", "fade_in_slide_out", or "static")
        render = "default",
        timeout = 3000,
      },
      config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        -- Set as default notify handler
        vim.notify = notify
      end,
    },

    -- UI enhancements
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      opts = {
        cmdline = {
          format = {
            filter = { pattern = "^:%s*!", icon = ">", ft = "zsh" },
          },
        },
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
    },

    -- Formatter
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          python = { "ruff" },
          javascript = { "biome" },
          json = { "biome" },
          typescript = { "biome" },
          typescriptreact = { "biome" },
        },
        format_on_save = {
          lsp_format = "fallback",
        },
      },
    },

    -- Lua development
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },

    -- TypeScript tools
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
    },

    -- Tailwind CSS
    {
      "luckasRanarison/tailwind-tools.nvim",
      name = "tailwind-tools",
      build = ":UpdateRemotePlugins",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {},
    },

    -- C# support
    {
      "seblyng/roslyn.nvim",
      ft = "cs",
      opts = {
        exe = "Microsoft.CodeAnalysis.LanguageServer",
      },
    },

    -- GitHub Copilot
    { "github/copilot.vim" },

    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        adapters = {
          chat = "copilot",
          inline = "copilot",
        },
        auto_close = {
          enabled = false,
        },
        window = {
          width = 0.4,
          height = 0.6,
          border = "rounded",
          title = {
            name = "Code Companion",
            position = "center",
          },
        },
        chat = {
          welcome_message = "👋 How can I help you today?",
          prompt_prefix = "🤔",
          model_prefix = "🤖",
          keymaps = {
            close = "q",
            reset = "<C-r>",
            complete = "<Tab>",
            submit = "<CR>",
          },
        },
        display = {
          action_palette = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
        submit_delay = 1500,
        prompt_library = {
          -- Original Code Review Workflow
          ["Code Review Workflow"] = {
            strategy = "workflow",
            description = "Review code, get feedback, and apply improvements",
            opts = {
              index = 1,
              is_default = true,
              short_name = "cr",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    return string.format(
                      "You are an expert software engineer for %s. Provide thoughtful, accurate code reviews with clear explanations.",
                      context.filetype
                    )
                  end,
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = "Please review the code I'm sharing and identify any bugs, performance issues, or style improvements:",
                  opts = { auto_submit = true },
                },
              },
              {
                {
                  role = "user",
                  content = "Great review. Now please suggest specific code improvements to address these issues.",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@editor Please implement these improvements directly in the code, focusing on the most critical issues first.",
                  opts = { auto_submit = false },
                },
              },
            },
          },

          -- Test-Driven Development Workflow
          ["TDD Workflow"] = {
            strategy = "workflow",
            description = "Improve code through test-driven development",
            opts = {
              index = 2,
              short_name = "tdd",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are an expert in test-driven development. Help improve code by writing tests and making necessary fixes.",
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = function()
                    vim.g.codecompanion_auto_tool_mode = true
                    return [[### Instructions
I need help improving this code using Test-Driven Development.

### Steps to Follow
1. First, review the code in #buffer{watch}
2. Use @editor to write appropriate tests for the code
3. Use @cmd_runner to run the tests
4. If tests fail, use @editor to fix the code
5. Continue this cycle until the tests pass

Let's start!]]
                  end,
                  opts = { auto_submit = true },
                },
              },
              {
                {
                  role = "user",
                  condition = function()
                    return _G.codecompanion_current_tool == "cmd_runner"
                  end,
                  repeat_until = function(chat)
                    return chat.tool_flags.testing == true
                  end,
                  content = "The tests have failed. Please improve the code to make the tests pass.",
                  opts = { auto_submit = true },
                },
              },
            },
          },

          -- Refactoring Workflow
          ["Refactoring Workflow"] = {
            strategy = "workflow",
            description = "Refactor code to improve design without changing functionality",
            opts = {
              index = 3,
              short_name = "refactor",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    return string.format(
                      "You are an expert in clean code principles and software design patterns for %s. Help refactor code to improve readability, maintainability, and design.",
                      context.filetype
                    )
                  end,
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = "Please analyze this code and suggest how it could be refactored to improve its design and maintainability while preserving its functionality:",
                  opts = { auto_submit = true },
                },
              },
              {
                {
                  role = "user",
                  content = "Great analysis. Now please refactor the code step by step, explaining each change you make and why it improves the design.",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@editor Please implement the refactoring changes you described.",
                  opts = { auto_submit = false },
                },
              },
            },
          },

          -- Documentation Generator Workflow
          ["Documentation Workflow"] = {
            strategy = "workflow",
            description = "Generate comprehensive documentation for code",
            opts = {
              index = 4,
              short_name = "docs",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    return string.format(
                      "You are an expert technical writer and %s developer who specializes in creating clear, comprehensive documentation.",
                      context.filetype
                    )
                  end,
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = "Please analyze this code and create comprehensive documentation that explains:",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@editor Please add documentation comments directly to the code, following best practices for this language. Include function/method documentation, important parameter descriptions, return values, examples where helpful, and any other relevant details.",
                  opts = { auto_submit = false },
                },
              },
            },
          },

          -- Bug Fix Workflow
          ["Bug Fix Workflow"] = {
            strategy = "workflow",
            description = "Diagnose and fix bugs in code",
            opts = {
              index = 5,
              short_name = "bugfix",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are an expert software engineer who specializes in debugging and fixing code issues.",
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = "I have some code with a bug in it. Please analyze the code, identify the potential issue(s), and explain what might be causing the problem:",
                  opts = { auto_submit = true },
                },
              },
              {
                {
                  role = "user",
                  content = "Great analysis. Can you suggest how to fix this bug?",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@editor Please implement the fix you suggested.",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@cmd_runner Let's verify the fix by running some tests or executing the code.",
                  opts = { auto_submit = false },
                },
              },
            },
          },

          -- Learning Assistant Workflow
          ["Learning Workflow"] = {
            strategy = "workflow",
            description = "Learn a new code pattern or concept with examples",
            opts = {
              index = 6,
              short_name = "learn",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    return string.format(
                      "You are an expert software engineer and educator specializing in %s. You're amazing at explaining complex concepts in simple terms with practical examples.",
                      context.filetype
                    )
                  end,
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = "I want to learn about a specific coding pattern or concept. Please explain the following concept in depth:",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "Great explanation! Can you show me a practical example of implementing this in my codebase?",
                  opts = { auto_submit = false },
                },
              },
              {
                {
                  role = "user",
                  content = "@editor Please insert a clear example of this pattern that fits with my existing code.",
                  opts = { auto_submit = false },
                },
              },
            },
          },

          -- Project Exploration Workflow
          ["Project Explorer"] = {
            strategy = "workflow",
            description = "Analyze and understand a new project structure",
            opts = {
              index = 7,
              short_name = "explore",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are an expert software architect who specializes in quickly understanding codebases and project structures.",
                  opts = { visible = false },
                },
                {
                  role = "user",
                  content = function()
                    return [[### Instructions
I need help understanding this project.

### What I need
1. Please analyze the files and code I'm sharing
2. Create a summary of:
   - Overall project architecture
   - Key components and their relationships
   - Main functionality
   - Design patterns used
   - Any areas that could use improvement
]]
                  end,
                  opts = { auto_submit = true },
                },
              },
              {
                {
                  role = "user",
                  content = "That's helpful! Can you explain in more detail how I might navigate and make changes to this codebase?",
                  opts = { auto_submit = false },
                },
              },
            },
          },
        },
      },
      keys = {
        { "<leader>cc", desc = "Code Companion" },
        { "<leader>ccc", "<cmd>CodeCompanionChat<cr>", desc = "Open Chat" },
        { "<leader>cca", "<cmd>CodeCompanionActions<cr>", desc = "Action Palette" },
        { "<leader>cct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle Chat" },
        { "<leader>ccr", "<cmd>CodeCompanionWorkflow 'Code Review Workflow'<cr>", desc = "Code Review" },
        { "<leader>ccd", "<cmd>CodeCompanionWorkflow 'TDD Workflow'<cr>", desc = "TDD" },
        { "<leader>ccf", "<cmd>CodeCompanionWorkflow 'Refactoring Workflow'<cr>", desc = "Refactor" },
        { "<leader>cco", "<cmd>CodeCompanionWorkflow 'Documentation Workflow'<cr>", desc = "Documentation" },
        { "<leader>ccb", "<cmd>CodeCompanionWorkflow 'Bug Fix Workflow'<cr>", desc = "Bug Fix" },
        { "<leader>ccl", "<cmd>CodeCompanionWorkflow 'Learning Workflow'<cr>", desc = "Learning" },
        { "<leader>ccp", "<cmd>CodeCompanionWorkflow 'Project Explorer'<cr>", desc = "Project Explore" },
      },
    },

    -- Completion
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

    -- Snacks for file navigation
    {
      "folke/snacks.nvim",
      opts = {
        picker = {},
      },
    },

    -- File manager
    {
      "mikavilpas/yazi.nvim",
      dependencies = { "folke/snacks.nvim" },
      event = "VeryLazy",
      opts = {
        open_for_directories = true,
        keymaps = {
          show_help = "<f1>",
        },
        integrations = {
          grep_in_directory = function(directory)
            require("snacks").picker.grep({ cwd = directory })
          end,
        },
      },
    },

    -- Debugging
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup({
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
        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
      end,
    },

    -- Python debugging
    {
      "mfussenegger/nvim-dap-python",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
      config = function()
        require("dap-python").setup("uv")
      end,
    },

    -- Linting
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
            if vim.opt_local.modifiable:get() then
              lint.try_lint()
            end
          end,
        })
      end,
    },
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {
        direction = "float",
        open_mapping = [[<c-\>]],
      },
    },
  },
  install = { colorscheme = { "tokyonight-night" } },
  checker = { enabled = true },
})
