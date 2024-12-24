return {
	"echasnovski/mini.notify",
	version = "*",
	config = function()
		local notify = require("mini.notify")
		vim.notify = notify.make_notify()
	end,
}
