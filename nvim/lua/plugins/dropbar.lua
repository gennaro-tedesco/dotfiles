local ok, dropbar = pcall(require, "dropbar")
if not ok then
	return
end

local icons = require("utils").icons

dropbar.setup({
	general = {
		update_events = {
			win = {
				"CursorMoved",
				"WinEnter",
				"WinResized",
			},
			buf = {
				"BufModifiedSet",
				"FileChangedShellPost",
				"TextChanged",
			},
			global = {
				"DirChanged",
				"VimResized",
			},
		},
	},
	bar = {
		pick = {
			pivots = "1234567890",
		},
	},
	menu = {
		keymaps = {
			["qq"] = function()
				vim.cmd.quit()
			end,
			["<Left>"] = "<C-w>c",
			["<Right>"] = function()
				local menu = require("dropbar.api").get_current_dropbar_menu()
				if not menu then
					return
				end
				local cursor = vim.api.nvim_win_get_cursor(menu.win)
				local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
				if component then
					menu:click_on(component, nil, 1, "l")
				end
			end,
		},
	},
	icons = {
		kinds = {
			symbols = {
				Array = icons.kinds.Array .. " ",
				Boolean = icons.kinds.Boolean .. " ",
				BreakStatement = "󰙧 ",
				Call = "󰃷 ",
				CaseStatement = "󱃙 ",
				Class = icons.kinds.Class .. " ",
				Color = icons.kinds.Color .. " ",
				Constant = icons.kinds.Constant .. " ",
				Constructor = icons.kinds.Constructor .. " ",
				ContinueStatement = "→ ",
				Copilot = " ",
				Declaration = "󰙠 ",
				Delete = "󰩺 ",
				DoStatement = "󰑖 ",
				Enum = icons.kinds.Enum .. " ",
				EnumMember = icons.kinds.EnumMember .. " ",
				Event = icons.kinds.Event .. " ",
				Field = icons.kinds.Field .. " ",
				File = icons.kinds.File .. " ",
				Folder = icons.kinds.Folder .. " ",
				ForStatement = "󰑖 ",
				Function = icons.kinds.Function .. " ",
				Identifier = "󰀫 ",
				IfStatement = "󰇉 ",
				Interface = icons.kinds.Interface .. " ",
				Keyword = icons.kinds.Keyword .. " ",
				List = icons.kinds.Array .. " ",
				Log = "󰦪 ",
				Lsp = " ",
				Macro = "󰁌 ",
				MarkdownH1 = "󰉫 ",
				MarkdownH2 = "󰉬 ",
				MarkdownH3 = "󰉭 ",
				MarkdownH4 = "󰉮 ",
				MarkdownH5 = "󰉯 ",
				MarkdownH6 = "󰉰 ",
				Method = icons.kinds.Method .. " ",
				Module = icons.kinds.Module .. " ",
				Namespace = icons.kinds.Namespace .. " ",
				Null = icons.kinds.Null .. " ",
				Number = icons.kinds.Number .. " ",
				Object = icons.kinds.Object .. " ",
				Operator = icons.kinds.Operator .. " ",
				Package = icons.kinds.Package .. " ",
				Property = icons.kinds.Property .. " ",
				Reference = icons.kinds.Reference .. " ",
				Regex = " ",
				Repeat = "󰑖 ",
				Scope = "󰅩 ",
				Snippet = icons.kinds.Snippet .. " ",
				Specifier = "󰦪 ",
				Statement = "󰅩 ",
				String = icons.kinds.String .. " ",
				Struct = icons.kinds.Struct .. " ",
				SwitchStatement = "󰺟 ",
				Terminal = " ",
				Text = icons.kinds.Text .. " ",
				Type = " ",
				TypeParameter = icons.kinds.TypeParameter .. " ",
				Unit = icons.kinds.Unit .. " ",
				Value = icons.kinds.Value .. " ",
				Variable = icons.kinds.Variable .. " ",
				WhileStatement = "󰑖 ",
			},
		},
	},
})
