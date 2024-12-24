return {
    {
        "echasnovski/mini.files",
        version = "*",
        config = function()
            local MiniFiles = require("mini.files")
            MiniFiles.setup()

            vim.keymap.set("n", "<leader>ef", function()
                MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
            end, { desc = "Open Explorer" })
        end,
    },
    {
        "echasnovski/mini.pick",
        version = "*",
        config = function()
            local MiniPick = require("mini.pick")
            MiniPick.setup()

            vim.keymap.set("n", "<leader>ff", function()
                MiniPick.start({ source = { items = vim.fn.readdir(".") } })
            end, { desc = "Pick" })
            vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep, { desc = "Pick" })
            vim.keymap.set("n", "<leader>fl", MiniPick.builtin.grep_live, { desc = "Pick" })
            vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "Pick" })

            -- local wipeout_cur = function()
            --     vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
            -- end
            -- local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
            --
            -- MiniPick.builtin.buffers(local_opts, { mappings = buffer_mappings })
        end,
    },
}
