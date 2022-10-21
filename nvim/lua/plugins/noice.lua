local function no_msg(kind, regex)
	return {
		filter = { event = "msg_show", kind = kind, find = regex },
		opts = { skip = true },
	}
end

local noice_hl = vim.api.nvim_create_augroup("NoiceHighlights", {})
vim.api.nvim_clear_autocmds({ group = noice_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = noice_hl,
	callback = function()
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderLua", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderLua", { link = "Constant" })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderFilter", {})
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderFilter", { link = "Constant" })
	end,
})

local cmdline_opts = {
	border = {
		style = "rounded",
		text = { top = "" },
	},
}

require("noice").setup({
	cmdline = {
		view = "cmdline_popup",
		format = {
			cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
			search_down = { kind = "Search", pattern = "^/", icon = "🔎 ", ft = "regex", opts = cmdline_opts },
			search_up = { kind = "Search", pattern = "^%?", icon = "🔎 ", ft = "regex", opts = cmdline_opts },
			filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
			f_filter = { pattern = "^:%s*%%%s*!", icon = " $", ft = "sh", opts = cmdline_opts },
			v_filter = { pattern = "^:%s*%'<,%'>%s*!", icon = " $", ft = "sh", opts = cmdline_opts },
			lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
			IncRename = {
				pattern = "^:%s*IncRename%s+",
				icon = " ",
				conceal = true,
				opts = {
					relative = "cursor",
					size = { min_width = 20 },
					position = { row = -3, col = 0 },
					buf_options = { filetype = "text" },
				},
			},
		},
	},
	messages = { view_search = false },
	lsp_progress = { view = "mini" },
	views = { split = { enter = true } },
	routes = {
		{ filter = { event = "msg_show", min_height = 10 }, view = "split" },
		no_msg(nil, "written"),
		no_msg(nil, "search hit BOTTOM"),
		no_msg("search_count", nil),
		no_msg("wmsg", nil),
		no_msg("emsg", "E23"),
		no_msg("emsg", "E20"),
		no_msg("emsg", "E37"),
	},
})
