return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<c-\>]],
        })
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
        function _lazygit_toggle()
            lazygit:toggle()
        end
        vim.keymap.set("n", "<leader>p", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
    end,
}
