return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "bash-language-server",
                    "biome",
                    "clang-format",
                    "editorconfig-checker",
                    "gofumpt",
                    "golangci-lint",
                    "golines",
                    "gomodifytags",
                    "gopls",
                    "gotests",
                    "jsonlint",
                    "lua-language-server",
                    "luacheck",
                    "markdownlint",
                    "mypy",
                    "ruff",
                    "shellcheck",
                    "shfmt",
                    "stylua",
                    "taplo",
                    "tailwindcss-language-server",
                    "yamllint",
                },
            })
        end,
    },
}
