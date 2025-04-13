local config = {
	select_symbol = "󰻭",
	yank_symbol = "",
	cut_symbol = "",
	branch_symbol = "",
}

local function setup()
	function Header:cwd()
		local max = self._area.w - self._right_width
		if max <= 0 then
			return ""
		end

		local s = ya.readable_path(tostring(self._current.cwd)) .. self:flags()
		return ui.Line({
			ui.Span(th.status.sep_left.open):fg(th.mgr.cwd.bg),
			ui.Span(" " .. ya.truncate(s, { max = max, rtl = true }) .. " "):style(th.mgr.cwd),
			ui.Span(th.status.sep_left.close):fg(th.mgr.cwd.bg),
		})
	end

	function Header:count()
		local files_yanked = #cx.yanked
		local files_selected = #cx.active.selected

		local selection_element = files_selected > 0 and config.select_symbol .. " " .. files_selected or ""
		local yank_icon = cx.yanked.is_cut and config.cut_symbol or config.yank_symbol
		local yank_colour = cx.yanked.is_cut and th.mgr.count_cut.bg or th.mgr.count_copied.bg
		local yank_element = files_yanked > 0 and yank_icon .. " " .. files_yanked or ""

		return ui.Line({
			ui.Span(selection_element .. " "):fg(th.mgr.count_selected.bg),
			ui.Span(yank_element .. " "):fg(yank_colour),
		})
	end

	function Header:get_branch()
		local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null"):read("*a")
		local branch = handle ~= nil and handle:gsub("%s+", "") or ""

		if branch ~= "" then
			return ui.Line({
				ui.Span(" " .. th.status.sep_left.open):fg(th.mgr.cwd.bg),
				ui.Span(config.branch_symbol .. " " .. branch):style(th.mgr.cwd):fg(th.status.perm_exec.fg),
				ui.Span(th.status.sep_left.close):fg(th.mgr.cwd.bg),
			})
		end
	end

	Header:children_add(Header.get_branch, 5000, Header.LEFT)
end

return { setup = setup }
