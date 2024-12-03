return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
    },
    keys = {
        --         local utils = require('utils')
        --
        -- utils.map('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
        -- utils.map('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
        -- utils.map('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
        -- utils.map('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
        -- utils.map('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
        --
        -- utils.map('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
        -- utils.map('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
        -- utils.map('v', '<leader>dhv',
        --           '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')
        --
        -- utils.map('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
        -- utils.map('n', '<leader>duf',
        --           "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")
        --
        -- utils.map('n', '<leader>dsbr',
        --           '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
        -- utils.map('n', '<leader>dsbm',
        --           '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
        -- utils.map('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
        -- utils.map('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')
        --
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
        local dap_utils = require("dap.utils")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            automatic_installation = true,
            ensure_installed = {
                "chrome",
                "codelldb",
                "debugpy",
                "delve",
                "js",
            },
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
        })

        ---@diagnostic disable-next-line: missing-fields
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            ---@diagnostic disable-next-line: missing-fields
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
        vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
        vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })

        local breakpoint_icons = vim.g.have_nerd_font
                and {
                    Breakpoint = "",
                    BreakpointCondition = "",
                    BreakpointRejected = "",
                    LogPoint = "",
                    Stopped = "",
                }
            or {
                Breakpoint = "●",
                BreakpointCondition = "⊜",
                BreakpointRejected = "⊘",
                LogPoint = "◆",
                Stopped = "⭔",
            }

        for type, icon in pairs(breakpoint_icons) do
            local tp = "Dap" .. type
            local hl = (type == "Stopped") and "DapStop" or "DapBreak"
            vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        dap.configurations.c = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                stdout = {
                    "index.txt",
                },
                preLaunchTask = "Compile",
            },
        }

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },
            },
        }

        require("dap-go").setup()
        require("dap-python").setup("python")

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {
                    vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                    "${port}",
                },
            },
        }

        dap.adapters["chrome"] = {
            type = "executable",
            command = "node",
            args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
        }

        for _, language in ipairs({
            "astro",
            "vue",
            "svelte",
            "typescript",
            "javascript",
            "typescriptreact",
            "javascriptreact",
        }) do
            dap.configurations[language] = {
                {
                    name = "Next.js: debug server-side",
                    type = "pwa-node",
                    request = "attach",
                    port = 9231,
                    skipFiles = { "<node_internals>/**", "node_modules/**" },
                    cwd = "${workspaceFolder}",
                },
                {
                    name = "Next.js: debug client-side",
                    type = "chrome",
                    request = "launch",
                    url = "http://localhost:3000",
                    webRoot = "${workspaceFolder}",
                    sourceMaps = true, -- https://github.com/vercel/next.js/issues/56702#issuecomment-1913443304
                    sourceMapPathOverrides = {
                        ["webpack://_N_E/*"] = "${webRoot}/*",
                    },
                },
                -- {
                --     name = "Next.js: debug full stack",
                --     type = "node",
                --     request = "launch",
                --     program = "${workspaceFolder}/node_modules/.bin/next",
                --     runtimeArgs = { "--inspect" },
                --     skipFiles = { "<node_internals>/**" },
                --     serverReadyAction = {
                --         action = "debugWithEdge",
                --         killOnServerStop = true,
                --         pattern = "- Local:.+(https?://.+)",
                --         uriFormat = "%s",
                --         webRoot = "${workspaceFolder}",
                --     },
                -- },
            }
        end
    end,
}
