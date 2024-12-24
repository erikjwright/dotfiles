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
                markdown = { "mdformat" },
                python = { "ruff_format" },
                rust = { "rustfmt", lsp_format = "fallback" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })
    end,
}
