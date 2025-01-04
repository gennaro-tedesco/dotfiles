local ok, noice = pcall(require, "noice")
if not ok then
	return
end

local noice_hl = vim.api.nvim_create_augroup("NoiceHighlights", {})
local noice_cmd_types = {
	CmdLine = "Constant",
	Input = "Constant",
	Calculator = "Constant",
	Lua = "Constant",
	Filter = "Constant",
	Rename = "Constant",
	Substitute = "NoiceCmdlinePopupBorderSearch",
	Help = "Todo",
}
vim.api.nvim_clear_autocmds({ group = noice_hl })
vim.api.nvim_create_autocmd("BufEnter", {
	group = noice_hl,
	desc = "redefinition of noice highlight groups",
	callback = function()
		for type, hl in pairs(noice_cmd_types) do
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, {})
			vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, { link = hl })
		end
		vim.api.nvim_set_hl(0, "NoiceConfirmBorder", {})
		vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = "Constant" })
	end,
})

local cmdline_opts = {
	border = {
		style = "rounded",
		text = { top = "" },
	},
}

noice.setup({
	presets = {
		bottom_search = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
	cmdline = {
		view = "cmdline_popup",
		format = {
			cmdline = { opts = cmdline_opts },
			input = { view = "cmdline", ft = "regex" },
			calculator = { view = "cmdline", pattern = "^:=", icon = "", lang = "vimnormal" },
			substitute = {
				pattern = "^:%%?s/",
				icon = "🔁",
				ft = "regex",
				opts = { border = { text = { top = " sub (old/new/) " } } },
			},
			filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
			filefilter = { kind = "Filter", pattern = "^:%s*%%%s*!", icon = "📄 $", ft = "sh", opts = cmdline_opts },
			selectionfilter = {
				kind = "Filter",
				pattern = "^:%s*%'<,%'>%s*!",
				icon = " $",
				ft = "sh",
				opts = cmdline_opts,
			},
			lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
			help = { pattern = "^:%s*h%s+", icon = "💡", opts = cmdline_opts },
		},
	},
	messages = { view_search = false },
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		hover = { enabled = true },
		signature = { enabled = false },
		documentation = {
			opts = {
				win_options = {
					concealcursor = "n",
					conceallevel = 3,
					winhighlight = {
						Normal = "Normal",
						FloatBorder = "Todo",
					},
				},
			},
		},
	},
	views = {
		split = { enter = true },
		mini = { win_options = { winblend = 0 } },
	},
	routes = {
		{ filter = { find = "E162" }, view = "mini" },
		{
			filter = {
				event = "msg_show",
				any = {
					{ find = "; after #%d+" },
					{ find = "; before #%d+" },
					{ find = "fewer lines" },
					{ find = "written" },
					{ find = "Conflict %[%d+" },
					{ find = "Col %d+" },
				},
			},
			view = "mini",
		},
		{ filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
		{ filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
		{ filter = { event = "emsg", find = "E23" }, skip = true },
		{ filter = { event = "emsg", find = "E20" }, skip = true },
		{ filter = { find = "No signature help" }, skip = true },
		{ filter = { find = "E37" }, skip = true },
		{ filter = { find = "E31" }, skip = true },
		{ filter = { find = "Error detected while processing BufReadPost Autocommands for" }, skip = true },
	},
})

vim.keymap.set({ "n", "i", "s" }, "<c-j>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-j>"
	end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-k>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-k>"
	end
end, { silent = true, expr = true })
