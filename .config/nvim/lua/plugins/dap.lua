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
				"folke/lazydev.nvim",
				ft = "lua",
				keys = {},
				opts = {
					library = {
						"nvim-dap-ui",
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
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

			require("dap.ext.vscode").load_launchjs(nil, {})

			local ensure_installed = {
				"bash",
				"codelldb",
				"chrome",
				"delve",
				"firefox",
				"js",
				"php",
				"pwa-node",
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

			require("mason-nvim-dap").setup({
				automatic_installation = false,
				ensure_installed = ensure_installed,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
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
			require("dap-python").setup("python")

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
