return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            {
                "mxsdev/nvim-dap-vscode-js",
                dependencies = {
                    "microsoft/vscode-js-debug",
                    opt = true,
                    run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
                },
            },
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
                "<F10>",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step Into",
            },
            {
                "<F11>",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step Over",
            },
            {
                "<F12>",
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
                "<F6>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Debug: See last session result.",
            },
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")

            -- require("dap.ext.vscode").load_launchjs(nil, {})

            local ensure_installed = {
                "bash",
                "codelldb",
                "chrome",
                "delve",
                "firefox",
                "js",
                "php",
                -- "pwa-node",
                "python",
            }

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

            require("dap-vscode-js").setup({
                -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                -- debugger_path = os.getenv("HOME") .. "/.local/share/nvim/mason/bin", -- Path to vscode-js-debug installation.
                debugger_path = vim.fn.stdpath("data") .. "/mason/bin",
                debugger_cmd = { "vscode-js-debug" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
            })

            require("mason-nvim-dap").setup({
                automatic_installation = true,
                ensure_installed = ensure_installed,
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })

            require("dap").adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "js-debug-adapter",
                    args = { "${port}" },
                },
            }

            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Debug",
                        -- trace = true, -- include debugger info
                        runtimeExecutable = "node",
                        -- runtimeArgs = {
                        --     "./node_modules/jest/bin/jest.js",
                        --     "--runInBand",
                        --     "${file}",
                        -- },
                        rootPath = "${workspaceFolder}/src",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                        port = 8123,
                    },
                }
            end

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

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            require("dap-go").setup()
            require("dap-python").setup()

            -- local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
            --
            -- dap.adapters.python = function(cb, config)
            -- 	if config.request == "attach" then
            -- 		---@diagnostic disable-next-line: undefined-field
            -- 		local port = (config.connect or config).port
            -- 		---@diagnostic disable-next-line: undefined-field
            -- 		local host = (config.connect or config).host or "127.0.0.1"
            -- 		cb({
            -- 			type = "server",
            -- 			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            -- 			host = host,
            -- 			options = {
            -- 				source_filetype = "python",
            -- 			},
            -- 		})
            -- 	else
            -- 		cb({
            -- 			type = "executable",
            -- 			command = path,
            -- 			args = { "-m", "debugpy.adapter" },
            -- 			options = {
            -- 				source_filetype = "python",
            -- 			},
            -- 		})
            -- 	end
            -- end
            --
            -- dap.configurations.python = {
            -- 	{
            -- 		-- The first three options are required by nvim-dap
            -- 		type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
            -- 		request = "launch",
            -- 		name = "Launch file",
            --
            -- 		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
            --
            -- 		program = "${file}", -- This configuration will launch the current file if used.
            -- 		pythonPath = function()
            -- 			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- 			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- 			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            -- 			local cwd = vim.fn.getcwd()
            -- 			if vim.fn.executable(cwd .. "/.env/bin/python") == 1 then
            -- 				return cwd .. "/.env/bin/python"
            -- 			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            -- 				return cwd .. "/.venv/bin/python"
            -- 			else
            -- 				return path
            -- 			end
            -- 		end,
            -- 	},
            -- }
            --
            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        -- -- Build the program before debugging
                        -- local output = vim.fn.input("Path to output binary: ", vim.fn.getcwd() .. "/hello", "file")
                        -- local source = vim.fn.input("Path to source file: ", vim.fn.getcwd() .. "/hello.c", "file")
                        -- local compiler = vim.fn.input("Compiler (default: gcc): ", "gcc", "file")
                        --
                        -- -- Run the build command
                        -- local cmd = string.format("%s -g %s -o %s", compiler, source, output)
                        -- local result = os.execute(cmd)
                        -- if result ~= 0 then
                        --     vim.notify("Build failed: " .. cmd, vim.log.levels.ERROR)
                        --     return nil
                        -- end
                        --
                        -- -- Return the output binary path
                        -- return output
                        --
                        -- Get the current file and determine the output binary name
                        local source = vim.fn.expand("%:p") -- Full path to the current file
                        local output = vim.fn.expand("%:p:r") -- Remove .c to get the output binary name

                        -- Build the program
                        local cmd = string.format("gcc -g %s -o %s", source, output)
                        local result = os.execute(cmd)
                        if result ~= 0 then
                            vim.notify("Build failed: " .. cmd, vim.log.levels.ERROR)
                            return nil
                        end

                        -- Return the compiled binary path
                        return output
                    end,
                    cwd = "${workspaceFolder}",
                    terminal = "integrated",
                },
            }
        end,
    },
}
