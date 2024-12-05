return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				go = { "gofumpt" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				lua = { "stylua" },
				python = { "ruff" },
				rust = { "rustfmt", lsp_format = "fallback" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
			},
			format_on_save = true,
		})
	end,
}
