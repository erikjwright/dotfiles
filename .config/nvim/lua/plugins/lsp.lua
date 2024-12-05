return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			local ensure_installed = {
				"astro",
				"bashls",
				"biome",
				"clangd",
				"cssls",
				"cssmodules_ls",
				"dockerls",
				"gopls",
				"graphql",
				"html",
				"htmx",
				"jqls",
				"lua_ls",
				"marksman",
				"mdx_analyzer",
				"phpactor",
				"prismals",
				"pyright",
				"ruby_lsp",
				"solc",
				"svelte",
				"tailwindcss",
				"terraformls",
				"taplo",
				"vacuum",
				"volar",
				"yamlls",
				"zls",
			}

			local handlers = {
				function(server_name)
					lspconfig[server_name].setup({})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			}

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				handlers = handlers,
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		config = function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction")
				-- or vim.lsp.buf.codeAction() if you don't want grouping.
			end, { silent = true, buffer = bufnr })
			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { silent = true, buffer = bufnr })
		end,
	},
}
