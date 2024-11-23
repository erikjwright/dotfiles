return {
    "nvim-treesitter/nvim-treesitter",
    enable = false,
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
  ensure_installed = {
	  "astro",
	  "c",
	  -- "comment",
	  "dockerfile",
	  "git_rebase",
	  "lua",
	  "markdown",
	  "markdown_inline",
	  "query",
	  "vim",
	  "vimdoc",
	"gitcommit",
	"gitignore",
	"graphql",
	"javascript",
	"jq",
	"jsdoc",
	"json",
	"prisma",
	"rust",
	"solidity",
	"sql",
	"svelte",
	"terraform",
	"toml",
	"typescript",
	"yaml",
	"zig"
  },
          sync_install = false,
          highlight = { enable = true},
          indent = { enable = false},  
	    additional_vim_regex_highlighting = false
    })
    end
 }
