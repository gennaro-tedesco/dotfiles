local M = {}

M.sessions_path = vim.fn.stdpath("data") .. "/sessions/"

M.new_session = function()
	local name = vim.fn.input("name: ")
	if name ~= "" then
		if next(vim.fs.find(name, { path = M.sessions_path })) == nil then
			vim.cmd.mksession({ args = { M.sessions_path .. name } })
			print("saved in: " .. M.sessions_path .. name)
		else
			print("session already exists")
		end
	end
end

M.update_session = function()
	local cs = vim.w["cs"]
	if cs ~= nil then
		local confirm = vim.fn.confirm("overwrite session?", "&Yes\n&No", 2)
		if confirm == 1 then
			vim.cmd.mksession({ args = { M.sessions_path .. cs }, bang = true })
		end
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
				vim.w["cs"] = selected[1]:gsub("^%./", "")
			end,
			["ctrl-v"] = function()
				print("sessions path: " .. M.sessions_path)
			end,
			["ctrl-x"] = function(selected)
				local confirm = vim.fn.confirm("delete session?", "&Yes\n&No", 2)
				if confirm == 1 then
					os.remove(M.sessions_path .. selected[1])
					print("deleted " .. M.sessions_path .. selected[1])
				end
			end,
		},
	})
end

return M
