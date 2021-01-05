------------------------------
---- custom lua functions ----
------------------------------

local function FloatingWindow(popup_height_ratio, popup_width_ratio)
   local screen_width = vim.api.nvim_list_uis()[1].width
   local screen_height = vim.api.nvim_list_uis()[1].height
   local popup_width = math.ceil(screen_width*popup_width_ratio)
   local popup_height = math.ceil(screen_height*popup_height_ratio)

   local opts = {
	  style = "minimal",
	  relative = "editor",
	  width = popup_width,
	  height = popup_height,
	  row = math.ceil((screen_height - popup_height)/2),
	  col = math.ceil((screen_width - popup_width)/2),
   }

   local border = {}
   local top = "╭" .. string.rep("─", popup_width - 2) .. "╮"
   local mid = "│" .. string.rep(" ", popup_width - 2) .. "│"
   local bot = "╰" .. string.rep("─", popup_width - 2) .. "╯"

   table.insert(border, top)
   for j=1, popup_height-2 do
	  table.insert(border, mid)
   end
   table.insert(border, bot)

   local external_buf = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_option(external_buf, 'bufhidden', 'wipe')
   vim.api.nvim_buf_set_lines(external_buf, 0, -1, true, border)
   vim.api.nvim_open_win(external_buf, true, opts)

   opts.row = opts.row + 1
   opts.height = opts.height - 2
   opts.col = opts.col + 2
   opts.width = opts.width - 4
   local internal_buf = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_buf_set_option(internal_buf, 'bufhidden', 'wipe')
   vim.api.nvim_open_win(internal_buf, true, opts)
   vim.api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..external_buf)
end


return {
   FloatingWindow = FloatingWindow,
}

