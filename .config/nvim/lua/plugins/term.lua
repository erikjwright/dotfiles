return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
    },
    {
        "willothy/wezterm.nvim",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                direction = "float",
            })

            local wezterm = require("wezterm")

            vim.keymap.set(
                "n",
                "<leader>wh",
                wezterm.split_pane.horizontal,
                { desc = "Split Wezterm Pane Horizontally" }
            )
            vim.keymap.set("n", "<leader>wv", wezterm.split_pane.vertical, { desc = "Split Wezterm Pane Vertically" })
            vim.keymap.set("n", "<leader>w\\", wezterm.zoom_pane, { desc = "Zoom Wezterm Pane" })
            vim.keymap.set("n", "<leader>wn", function()
                wezterm.switch_pane.direction("Right")
            end, { desc = "Switch Wezterm Pane Right" })
            vim.keymap.set("n", "<leader>wp", function()
                wezterm.switch_pane.direction("Left")
            end, { desc = "Switch Wezterm Pane Left" })
        end,
    },
}
