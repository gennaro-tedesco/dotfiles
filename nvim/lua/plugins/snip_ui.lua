local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end

local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choiceNode(choiceNode)
	local buf = vim.api.nvim_create_buf(false, true)
	local buf_text = {}
	local row_selection = 0
	local row_offset = 0
	local text
	for _, node in ipairs(choiceNode.choices) do
		text = node:get_docstring()
		if node == choiceNode.active_choice then
			row_selection = #buf_text
			row_offset = #text
		end
		vim.list_extend(buf_text, text)
	end

	vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
	local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

	local extmark = vim.api.nvim_buf_set_extmark(
		buf,
		current_nsid,
		row_selection,
		0,
		{ hl_group = "incsearch", end_line = row_selection + row_offset }
	)

	-- shows window at a beginning of choiceNode.
	local win = vim.api.nvim_open_win(buf, false, {
		relative = "win",
		width = w,
		height = h,
		bufpos = choiceNode.mark:pos_begin_end(),
		style = "minimal",
		border = "rounded",
	})

	return { win_id = win, extmark = extmark, buf = buf }
end

local function choice_popup(choiceNode)
	if current_win then
		vim.api.nvim_win_close(current_win.win_id, true)
		vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	end
	local create_win = window_for_choiceNode(choiceNode)
	current_win = {
		win_id = create_win.win_id,
		prev = current_win,
		node = choiceNode,
		extmark = create_win.extmark,
		buf = create_win.buf,
	}
end

local function update_choice_popup(choiceNode)
	---@cast current_win -nil
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	local create_win = window_for_choiceNode(choiceNode)
	current_win.win_id = create_win.win_id
	current_win.extmark = create_win.extmark
	current_win.buf = create_win.buf
end

local function choice_popup_close()
	---@cast current_win -nil
	vim.api.nvim_win_close(current_win.win_id, true)
	vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
	current_win = current_win.prev
	if current_win then
		local create_win = window_for_choiceNode(current_win.node)
		current_win.win_id = create_win.win_id
		current_win.extmark = create_win.extmark
		current_win.buf = create_win.buf
	end
end

local choice_popup_g = vim.api.nvim_create_augroup("LuaSnipChoicePopup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	pattern = "LuasnipChoiceNodeEnter",
	group = choice_popup_g,
	callback = function(_)
		choice_popup(ls.session.event_node)
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "LuasnipChoiceNodeLeave",
	group = choice_popup_g,
	callback = function(_)
		choice_popup_close()
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "LuasnipChangeChoice",
	group = choice_popup_g,
	callback = function(_)
		update_choice_popup(ls.session.event_node)
	end,
})
