return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		opts = {},

	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{ name = 'nvim_lsp' },
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({}),
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
		},
		init = function()
			vim.opt.signcolumn = 'yes'
		end,
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_defaults = lspconfig.util.default_config
			local lsp_zero = require('lsp-zero')

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lsp_defaults.capabilities = vim.tbl_deep_extend(
				'force',
				lsp_defaults.capabilities,
				require('cmp_nvim_lsp').default_capabilities()
			)

			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local opts = { buffer = event.buf }

					lsp_zero.default_keymaps(opts)

					vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
					vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
					vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
					vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
					vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
					vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
					vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
					vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
					vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
					vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						vim.keymap.set('n', '<leader>th', function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
							end,
							{ desc = '[T]oggle Inlay [H]ints' })
					end
				end,
			})

			local servers = {
				-- clangd = {},
				-- gopls = {},
				pyright = {},
				lua_ls = {},
				rust_analyzer = {},
				ts_ls = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})

			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup({
				ensure_installed = ensure_installed,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({})
					end,
					biome = function()
						lspconfig.biome.setup({
							single_file_support = false,
							filetypes = {
								"astro", "css", "graphql", "javascript", "javascriptreact", "json", "jsonc", "svelte",
								"typescript", "typescript.tsx", "typescriptreact", "vue"
							}
						})
					end,
					lua_ls = function()
						lspconfig.lua_ls.setup({
							on_init = function(client)
								lsp_zero.nvim_lua_settings(client, {})
							end,
						})
					end,
				}
			})


			lsp_zero.format_on_save({
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				servers = {
					['astro-language-server'] = { 'astro' },
					['biome'] = { 'javascript', 'typescript' },
					['rust_analyzer'] = { 'rust' },
					['lua_ls'] = { 'lua' }
				}
			})
		end
	}
}
