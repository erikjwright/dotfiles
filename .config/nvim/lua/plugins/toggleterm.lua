return {
	{
		"akinsho/toggleterm.nvim",
		version = "2.12",
		keys = {
			{
				"<c-/>",
				function()
					require("toggleterm").toggle(0, 20)
				end,
				desc = "Toggle terminal",
			},
			{ '<leader>tr', function() require("toggleterm").toggle(0, 20) end, 'Term Run Cargo' },
			-- { '<leader>tt', require("toggleterm").toggle(0, 20):exec("cargo test"), 'Term Run Cargo Test' },
		},
	},
}
