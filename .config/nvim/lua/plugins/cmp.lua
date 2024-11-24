return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "onsails/lspkind.nvim",
        "zbirenbaum/copilot-cmp",
        "neovim/nvim-lspconfig",
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
        },
    },
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            preselect = cmp.PreselectMode.None,
            sources = {
                { name = "copilot" },
                { name = "path" },
                { name = "luasnip" },
                { name = "nvim_lsp" },
            },
            mapping = cmp.mapping.preset.insert({
                ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                -- ["<down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                -- ["<up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<c-e>"] = cmp.mapping {
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                },
                ["<c-y>"] = cmp.mapping.confirm { select = true },
            }),
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            -- formatting = {
            --     format = require("lspkind").cmp_format({
            --         mode = "symbol",
            --         max_width = 50,
            --         symbol_map = { Copilot = "" },
            --     }),
            -- },
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
