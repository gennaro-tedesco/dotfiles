local icons = require("utils").icons

local function range_contains_pos(range, line, char)
	local start_pos = vim.pos(range.start.line, range.start.character)
	local adjusted_end_pos = vim.pos(range["end"].line, range["end"].character + 1)
	local vim_range = vim.range(start_pos, adjusted_end_pos)
	local current_pos = vim.pos(line, char)
	local single_pos_range = vim.range(current_pos, current_pos)
	return vim_range:has(single_pos_range)
end

local function get_symbol_path(symbol_list, line, char, path)
	if not symbol_list or #symbol_list == 0 then
		return false
	end

	for _, symbol in ipairs(symbol_list) do
		if symbol.range and range_contains_pos(symbol.range, line, char) then
			local icon = icons.kinds[vim.lsp.protocol.SymbolKind[symbol.kind]] or ""
			local icon_hl = vim.lsp.protocol.SymbolKind[symbol.kind]
					and "%#@lsp.type." .. string.lower(vim.lsp.protocol.SymbolKind[symbol.kind]) .. "#"
				or "%#Normal#"
			table.insert(path, icon_hl .. icon .. "%#Normal#" .. " " .. symbol.name)
			get_symbol_path(symbol.children, line, char, path)
			return true
		end
	end
	return false
end

local function lsp_callback(err, symbols)
	if err or not symbols then
		vim.o.winbar = ""
		return
	end

	local winnr = vim.api.nvim_get_current_win()
	local pos = vim.api.nvim_win_get_cursor(0)
	local cursor_line = pos[1] - 1
	local cursor_char = pos[2]

	local breadcrumbs = {}
	get_symbol_path(symbols, cursor_line, cursor_char, breadcrumbs)
	local breadcrumb_string = table.concat(breadcrumbs, " ➤ ")

	if breadcrumb_string ~= "" then
		vim.api.nvim_set_option_value("winbar", breadcrumb_string, { win = winnr })
	end
end

local function breadcrumbs_set()
	local bufnr = vim.api.nvim_get_current_buf()

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/documentSymbol") then
			local uri = vim.lsp.util.make_text_document_params(bufnr)["uri"]
			if not uri then
				return
			end

			local params = {
				textDocument = {
					uri = uri,
				},
			}

			local buf_src = uri:sub(1, uri:find(":") - 1)
			if buf_src ~= "file" then
				vim.o.winbar = ""
				return
			end

			vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, lsp_callback)
			return
		end
	end
end

local breadcrumbs_augroup = vim.api.nvim_create_augroup("Breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	group = breadcrumbs_augroup,
	callback = breadcrumbs_set,
	desc = "Set breadcrumbs.",
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = breadcrumbs_augroup,
	callback = function()
		vim.o.winbar = ""
	end,
	desc = "Clear breadcrumbs when leaving window.",
})
