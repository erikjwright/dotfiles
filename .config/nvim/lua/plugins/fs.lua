return {
  {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim", lazy = true },
    event = "VeryLazy",
    opts = {
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    keys = {
      {
        "<c-y>",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      -- {
      --   "<c-y>",
      --   "<cmd>Yazi cwd<cr>",
      --   desc = "Open the file manager in nvim's working directory",
      -- },
      -- {
      --   -- NOTE: this requires a version of yazi that includes
      --   -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      --   "<c-up>",
      --   "<cmd>Yazi toggle<cr>",
      --   desc = "Resume the last yazi session",
      -- },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- require "fzf-lua".setup { defaults = { git_icons = false } }
      vim.api.nvim_set_keymap("n", "<c-\\>", [[<Cmd>lua require"fzf-lua".buffers()<cr>]], {})
      vim.api.nvim_set_keymap("n", "<c-b>", [[<Cmd>lua require"fzf-lua".builtin()<cr>]], {})
      vim.api.nvim_set_keymap("n", "<c-p>", [[<Cmd>lua require"fzf-lua".files()<cr>]], {})
      -- vim.api.nvim_set_keymap("n", "<c-z>", [[<Cmd>lua require"fzf-lua".live_grep_glob()<cr>]], {})
      vim.api.nvim_set_keymap("n", "<c-g>", [[<Cmd>lua require"fzf-lua".grep_project()<cr>]], {})
      vim.api.nvim_set_keymap("n", "<f1>", [[<Cmd>lua require"fzf-lua".help_tags()<cr>]], {})
    end,
  },
}
