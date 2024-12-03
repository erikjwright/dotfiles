return {
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            if vim.g.have_nerd_font then
                local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
                local diagnostic_signs = {}
                for type, icon in pairs(signs) do
                    diagnostic_signs[vim.diagnostic.severity[type]] = icon
                end
                vim.diagnostic.config({ signs = { text = diagnostic_signs } })
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()

            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                clangd = {},
                gopls = {},
                pyright = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            runtime = {
                                -- Tell the language server which version of Lua you're using (most likely LuaJIT in Neovim)
                                version = "LuaJIT",
                                -- Setup your Lua path
                                path = vim.split(package.path, ";"),
                            },
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = { "vim" },
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = vim.api.nvim_get_runtime_file("", true),
                                -- Prevent the server from complaining about too many files
                                maxPreload = 10000,
                                preloadFileSize = 10000,
                            },
                            telemetry = {
                                enable = false, -- Do not send telemetry data
                            },
                        },
                    },
                },
                zls = {},
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})

            vim.list_extend(ensure_installed, {
                "biome",
                "clang-format",
                "cpplint",
                "gofumpt",
                "golangci-lint",
                "jsonlint",
                "luacheck",
                "markdownlint",
                "ruff",
                "shellcheck",
                "stylua",
                "taplo",
                "yamlfmt",
                "yamllint",
            })

            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}

                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
}
