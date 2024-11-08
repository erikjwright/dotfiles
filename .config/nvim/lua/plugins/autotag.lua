return {
	'windwp/nvim-ts-autotag',
	event = { 'InsertEnter' },
	config = function()
		local autotag_status_ok, autotag = pcall(require, 'nvim-ts-autotag')

		if not autotag_status_ok then
			return
		end

		autotag.setup({})
	end
}
