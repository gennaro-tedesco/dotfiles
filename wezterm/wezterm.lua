local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

local colour_scheme = "Solarized Dark Higher Contrast"
local scheme_def = wezterm.color.get_builtin_schemes()[colour_scheme]

config = {
	--- general wezterm behaviour
	automatically_reload_config = true,
	audible_bell = "Disabled",
	scrollback_lines = 10000,
	enable_scroll_bar = true,
	cursor_blink_rate = 400,
	disable_default_key_bindings = true,

	--- appearance
	font_size = 20,
	font = wezterm.font("Fira Code"),
	color_scheme = colour_scheme,
	colors = {
		scrollbar_thumb = scheme_def.ansi[1],
		tab_bar = {
			active_tab = {
				bg_color = scheme_def.background,
				fg_color = scheme_def.foreground,
			},
			inactive_tab = {
				bg_color = scheme_def.ansi[1],
				fg_color = scheme_def.foreground,
			},
			new_tab = {
				bg_color = scheme_def.background,
				fg_color = scheme_def.foreground,
			},
			new_tab_hover = {
				bg_color = scheme_def.background,
				fg_color = scheme_def.foreground,
			},
			inactive_tab_hover = {
				bg_color = scheme_def.selection_bg,
				fg_color = scheme_def.selection_fg,
			},
			inactive_tab_edge = scheme_def.ansi[1],
		},
		selection_bg = "#214283",
		copy_mode_inactive_highlight_bg = { Color = scheme_def.ansi[7] },
	},

	--- windows and tabs
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
	skip_close_confirmation_for_processes_named = { "zsh", "nvim", "k9s" },
	window_padding = {
		left = 50,
		right = 50,
		top = 50,
		bottom = 50,
	},
	window_frame = {
		font = wezterm.font("Museo"),
		font_size = 24,
		active_titlebar_bg = scheme_def.ansi[1],
		inactive_titlebar_bg = scheme_def.ansi[1],
	},

	--- keymaps
	keys = {
		{
			key = "t",
			mods = "CMD",
			action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		},
		{
			key = "r",
			mods = "CMD|SHIFT",
			action = act.ReloadConfiguration,
		},
		{
			key = "v",
			mods = "CMD",
			action = act.PasteFrom("Clipboard"),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = act.ShowDebugOverlay,
		},
		{
			key = "q",
			mods = "CMD",
			action = act.CloseCurrentPane({ confirm = false }),
		},
		{
			key = "f",
			mods = "CTRL",
			action = act.Search({ Regex = "" }),
		},
	},

	--- mouse configuration
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = { WheelUp = 1 } } },
			mods = "NONE",
			action = act.ScrollByLine(-10),
			alt_screen = false,
		},
		{
			event = { Down = { streak = 1, button = { WheelDown = 1 } } },
			mods = "NONE",
			action = act.ScrollByLine(10),
			alt_screen = false,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("ClipboardAndPrimarySelection"),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
	},
	selection_word_boundary = " {}[]()\"'`=",
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.ActivateTab(i - 1),
	})
end

wezterm.on("format-tab-title", function(tab)
	local padding = 5
	local cwd = string.format("%s", tab.active_pane.current_working_dir)
	local path = {}
	for token in string.gmatch(cwd, "[^%/]+") do
		table.insert(path, token)
	end
	local title
	if path[#path] == os.getenv("USER") then
		title = string.format(string.rep(" ", padding) .. "~" .. string.rep(" ", padding))
	else
		title = string.format(string.rep(" ", padding) .. "%s" .. string.rep(" ", padding), path[#path])
	end

	return wezterm.format({ { Text = title } })
end)

wezterm.on("new-tab-button-click", function(window, pane)
	window:perform_action(wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }), pane)
	return false
end)

return config
