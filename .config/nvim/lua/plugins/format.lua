return {
    -- {
    --   "windwp/nvim-autopairs",
    --   event = "InsertEnter",
    --   opts = true,
    -- },
    "windwp/nvim-ts-autotag",
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.surround").setup()
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff" },
                rust = { "rustfmt" },
                javascript = { "biome" },
                json = { "biome" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },
    "zapling/mason-conform.nvim",
}
