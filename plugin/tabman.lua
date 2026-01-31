vim.api.nvim_create_user_command("Tabman", function(opt)
	require("tabman").open()
end, { nargs = "*" })
