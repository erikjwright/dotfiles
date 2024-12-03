return {
    "echasnovski/mini.nvim",
    config = function()
        require("mini.ai").setup({ n_lines = 500 })

        local miniclue = require("mini.clue")

        miniclue.setup({
            triggers = {
                -- Leader triggers
                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },

                -- Built-in completion
                { mode = "i", keys = "<C-x>" },

                -- `g` key
                { mode = "n", keys = "g" },
                { mode = "x", keys = "g" },

                -- Marks
                { mode = "n", keys = "'" },
                { mode = "n", keys = "`" },
                { mode = "x", keys = "'" },
                { mode = "x", keys = "`" },

                -- Registers
                { mode = "n", keys = '"' },
                { mode = "x", keys = '"' },
                { mode = "i", keys = "<C-r>" },
                { mode = "c", keys = "<C-r>" },

                -- Window commands
                { mode = "n", keys = "<C-w>" },

                -- `z` key
                { mode = "n", keys = "z" },
                { mode = "x", keys = "z" },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
        })
        require("mini.diff").setup()
        require("mini.extra").setup()
        require("mini.files").setup()
        require("mini.git").setup()
        require("mini.icons").setup()
        require("mini.notify").setup()

        vim.notify = require("mini.notify").make_notify({ ERROR = { duration = 10000 } })

        require("mini.pick").setup({ window = { config = { border = "double" } } })

        vim.ui.select = MiniPick.ui_select
        vim.keymap.set("n", ",", [[<Cmd>Pick buf_lines scope='current' preserve_order=true<CR>]], { nowait = true })

        require("mini.surround").setup()

        local statusline = require("mini.statusline")

        statusline.setup({ use_icons = vim.g.have_nerd_font })

        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return "%2l:%-2v"
        end

        local test = require("mini.test")
        local reporter = test.gen_reporter.buffer({ window = { border = "double" } })

        test.setup({
            execute = { reporter = reporter },
        })
    end,
}
