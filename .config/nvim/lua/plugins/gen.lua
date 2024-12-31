return {
    -- {
    --     "olimorris/codecompanion.nvim",
    --     dependencies = {
    --         { "nvim-lua/plenary.nvim", branch = "master" },
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("codecompanion").setup({
    --             strategies = {
    --                 chat = {
    --                     adapter = "ollama",
    --                 },
    --                 inline = {
    --                     adapter = "ollama",
    --                 },
    --                 agent = {
    --                     adapter = "ollama",
    --                 },
    --             },
    --             server = {
    --                 url = "127.0.0.1:11434",
    --             },
    --             model = "llama3.2",
    --         })
    --         vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    --         vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    --         vim.api.nvim_set_keymap(
    --             "n",
    --             "<LocalLeader>a",
    --             "<cmd>CodeCompanionChat Toggle<cr>",
    --             { noremap = true, silent = true }
    --         )
    --         vim.api.nvim_set_keymap(
    --             "v",
    --             "<LocalLeader>a",
    --             "<cmd>CodeCompanionChat Toggle<cr>",
    --             { noremap = true, silent = true }
    --         )
    --         vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    --
    --         -- Expand 'cc' into 'CodeCompanion' in the command line
    --         vim.cmd([[cab cc CodeCompanion]])
    --     end,
    -- },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
    },
}
