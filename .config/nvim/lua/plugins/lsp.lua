return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
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
                -- "htmx",
                "jqls",
                "lua_ls",
                "marksman",
                "mdx_analyzer",
                "phpactor",
                "prismals",
                "pyright",
                "ruby_lsp",
                "ruff",
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

            local on_attach = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("la", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Arguments popup")
                map("lc", "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action")
                map("ld", "<Cmd>lua vim.diagnostic.open_float()<CR>", "Diagnostics popup")
                -- map("lf", formatting_cmd, "Format")
                map("li", "<Cmd>lua vim.lsp.buf.hover()<CR>", "Information")
                map("lj", "<Cmd>lua vim.diagnostic.goto_next()<CR>", "Next diagnostic")
                map("lk", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", "Prev diagnostic")
                map("lR", "<Cmd>lua vim.lsp.buf.references()<CR>", "References")
                map("lr", "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
                map("ls", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Source definition")
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            local handlers = {
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME,
                                        "${3rd}/luv/library",
                                        -- "${3rd}/busted/library",
                                    },
                                },
                            },
                        },
                    })
                end,
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        settings = {
                            python = {
                                pythonPath = os.getenv("HOME") .. "/.config/miniconda/bin/python",
                                venvPath = os.getenv("HOME") .. "/.config/miniconda/envs",
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    -- extraPaths = {
                                    --     vim.fn.getcwd(),
                                    -- },
                                },
                            },
                        },
                    })
                end,
            }

            require("mason-lspconfig").setup({
                automatic_installation = true,
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
    {
        "elixir-tools/elixir-tools.nvim",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup({
                nextls = { enable = true },
                elixirls = {
                    enable = true,
                    settings = elixirls.settings({
                        dialyzerEnabled = false,
                        enableTestLenses = false,
                    }),
                    on_attach = function()
                        vim.keymap.set("n", "<space>xf", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("n", "<space>xt", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("v", "<space>xx", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                    end,
                },
                projectionist = {
                    enable = true,
                },
            })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
}
