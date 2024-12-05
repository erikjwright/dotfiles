return {
	"echasnovski/mini.files",
	config = function()
		local MiniFiles = require("mini.files")

		MiniFiles.setup()

		vim.keymap.set("n", "<leader>ef", function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
		end, { desc = "Open Explorer" })
	end,
}
