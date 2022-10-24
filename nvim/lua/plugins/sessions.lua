local M = {}

M.sessions_path = vim.fn.stdpath("data") .. "/sessions/"

M.save_session = function()
	local name = vim.fn.input("name: ")
	print(name)
	if name ~= "" then
		vim.cmd.mksession({ args = { M.sessions_path .. name }, bang = true })
		print("saved in: " .. M.sessions_path .. name)
	end
end

M.load_session = function()
	require("fzf-lua").files({
		prompt = "sessions:",
		path_shorten = true,
		show_cwd_header = false,
		cwd = M.sessions_path,
		actions = {
			["default"] = function(selected)
				vim.cmd.source(M.sessions_path .. selected[1])
			end,
			["ctrl-v"] = function()
				print("sessions path: " .. M.sessions_path)
			end,
			["ctrl-x"] = function(selected)
				local confirm = vim.fn.confirm("delete session?", "&Yes\n&No", 2)
				if confirm then
					os.remove(M.sessions_path .. selected[1])
					print("deleted " .. M.sessions_path .. selected[1])
				end
			end,
		},
	})
end

return M
