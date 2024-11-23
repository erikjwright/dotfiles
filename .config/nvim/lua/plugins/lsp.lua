return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            vim.keymap.set("n", "?", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            vim.keymap.set("n", "g?", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            vim.keymap.set("n", "td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
            -- vim.keymap.set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            vim.keymap.set("n", "af", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
            vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
            vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
            vim.keymap.set("n", "lc", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
            vim.keymap.set("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = false,
                    signs = true,
                    update_in_insert = false,
                })
        end

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
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
            },
        })
    end,
}
