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
	cursor_blink_rate = 400,
	disable_default_key_bindings = true,

	--- appearance
	font_size = 20,
	font = wezterm.font("Fira Code"),
	color_scheme = colour_scheme,
	colors = {
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
			inactive_tab_hover = {
				bg_color = scheme_def.selection_bg,
				fg_color = scheme_def.selection_fg,
			},
		},
	},

	--- windows and tabs
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",
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
	},

	--- keymaps
	keys = {
		{
			key = "t",
			mods = "CMD",
			action = wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		},
		{
			key = "r",
			mods = "CMD|SHIFT",
			action = wezterm.action.ReloadConfiguration,
		},
		{
			key = "v",
			mods = "CMD",
			action = act.PasteFrom("Clipboard"),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ShowDebugOverlay,
		},
		{
			key = "q",
			mods = "CMD",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
	},

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
	},
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

return config
