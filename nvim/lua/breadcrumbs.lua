local icons = require("utils").icons

local function range_contains_pos(bufnr, range, line, char, position_encoding)
	local vim_range = vim.range.lsp(bufnr, range, position_encoding)
	local current_pos = vim.pos(line, char, { buf = bufnr })
	return vim_range:has(current_pos)
end

local function get_symbol_path(bufnr, symbol_list, line, char, path, position_encoding)
	if not symbol_list or #symbol_list == 0 then
		return false
	end

	for _, symbol in ipairs(symbol_list) do
		local symbol_range = symbol.range or (symbol.location and symbol.location.range)
		if symbol_range and range_contains_pos(bufnr, symbol_range, line, char, position_encoding) then
			local kind_name = vim.lsp.protocol.SymbolKind[symbol.kind]
			local icon = icons.kinds[kind_name] or ""
			local icon_hl = kind_name and "%#@lsp.type." .. string.lower(kind_name) .. "#" or "%#Normal#"
			table.insert(path, icon_hl .. icon .. "%#Normal# " .. symbol.name)
			get_symbol_path(bufnr, symbol.children, line, char, path, position_encoding)
			return true
		end
	end

	return false
end

local function lsp_callback(bufnr, winnr, position_encoding)
	return function(err, symbols)
		if err or not symbols or not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winnr) then
			pcall(vim.api.nvim_set_option_value, "winbar", "", { win = winnr })
			return
		end

		if vim.api.nvim_win_get_buf(winnr) ~= bufnr then
			return
		end

		local pos = vim.api.nvim_win_get_cursor(winnr)
		local cursor_line = pos[1] - 1
		local cursor_char = pos[2]

		local breadcrumbs = {}
		get_symbol_path(bufnr, symbols, cursor_line, cursor_char, breadcrumbs, position_encoding)
		local breadcrumb_string = table.concat(breadcrumbs, " ➤ ")

		vim.api.nvim_set_option_value("winbar", breadcrumb_string, { win = winnr })
	end
end

local function breadcrumbs_set(args)
	local bufnr = args and args.buf or vim.api.nvim_get_current_buf()
	local winnr = vim.api.nvim_get_current_win()

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/documentSymbol") then
			local uri = vim.uri_from_bufnr(bufnr)
			if not uri then
				return
			end

			local buf_src = uri:match("^([^:]+):")
			if buf_src ~= "file" then
				vim.api.nvim_set_option_value("winbar", "", { win = winnr })
				return
			end

			local params = {
				textDocument = {
					uri = uri,
				},
			}

			local position_encoding = client.offset_encoding or "utf-16"
			vim.lsp.buf_request(
				bufnr,
				"textDocument/documentSymbol",
				params,
				lsp_callback(bufnr, winnr, position_encoding)
			)
			return
		end
	end
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
	group = breadcrumbs_augroup,
	callback = breadcrumbs_set,
	desc = "Set breadcrumbs.",
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = breadcrumbs_augroup,
	callback = function(args)
		local win = vim.api.nvim_get_current_win()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_option_value("winbar", "", { win = win })
		end
	end,
	desc = "Clear breadcrumbs when leaving window.",
})
