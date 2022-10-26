local M = {}

M.config = {
	sessions_path = vim.fn.stdpath("data") .. "/sessions/",
	sessions_variable = "session",
	sessions_icon = "",
}

M.status = function()
	local cur_session = vim.w[M.config.sessions_variable]
	return cur_session ~= nil and M.config.sessions_icon .. ":" .. cur_session or nil
end

M.new_session = function()
	local name = vim.fn.input("name: ")
	if name ~= "" then
		if next(vim.fs.find(name, { path = M.config.sessions_path })) == nil then
			vim.cmd.mksession({ args = { M.config.sessions_path .. name } })
			print("saved in: " .. M.config.sessions_path .. name)
		else
			print("session already exists")
		end
	end
end

M.update_session = function()
	local cur_session = vim.w[M.config.sessions_variable]
	if cur_session ~= nil then
		local confirm = vim.fn.confirm("overwrite session?", "&Yes\n&No", 2)
		if confirm == 1 then
			vim.cmd.mksession({ args = { M.config.sessions_path .. cur_session }, bang = true })
			print("updated session: " .. cur_session)
		end
	end
end

M.delete_session = function(selected)
	local session = M.config.sessions_path .. selected[1]
	local confirm = vim.fn.confirm("delete session?", "&Yes\n&No", 2)
	if confirm == 1 then
		os.remove(session)
		print("deleted " .. session)
		if vim.w[M.config.sessions_variable] == vim.fs.basename(session) then
			vim.w[M.config.sessions_variable] = nil
		end
	end
end
require("fzf-lua").config.set_action_helpstr(M.delete_session, "delete-session")

M.load_session = function(selected)
	local session = M.config.sessions_path .. selected[1]
	vim.cmd.source(session)
	vim.w[M.config.sessions_variable] = vim.fs.basename(session)
end
require("fzf-lua").config.set_action_helpstr(M.load_session, "load-session")

M.list_sessions = function()
	require("fzf-lua").files({
		prompt = "sessions:",
		path_shorten = true,
		show_cwd_header = false,
		cwd = M.config.sessions_path,
		previewer = false,
		preview = require("fzf-lua").shell.raw_preview_action_cmd(function(selected)
			return string.format(
				"rg badd " .. M.config.sessions_path .. selected[1]:gsub("^%./", "") .. "| cut -f3 -d' '"
			)
		end),
		fzf_opts = {
			["--preview-window"] = "nohidden,down,50%",
		},
		winopts = {
			height = 0.5,
		},
		actions = {
			["default"] = M.load_session,
			["ctrl-x"] = M.delete_session,
		},
	})
end

return M
