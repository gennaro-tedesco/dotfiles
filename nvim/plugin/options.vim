"" --------------------------------------------
"" - customisation of default plugins options -
"" --------------------------------------------
let g:python3_host_prog = '/usr/local/bin/python3'

let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`', '```':'```', '"""':'"""'}
let g:AutoPairsShortcutFastWrap = '<C-w>'

let g:floaterm_autoclose = 2
let g:floaterm_keymap_toggle = '<F2>'
let g:floaterm_width = 0.85
let g:floaterm_height = 0.9
let g:floaterm_rootmarkers = ['.git']
let g:floaterm_opener = 'edit'
let g:floaterm_title = ''

let g:git_messenger_date_format = '%d %b %Y, %X'
let g:git_messenger_no_default_mappings = v:true
let g:git_messenger_include_diff = 'current'
let g:git_messenger_always_into_popup = v:true
let g:git_messenger_floating_win_opts = { 'border': 'rounded' }
let g:git_messenger_popup_content_margins = v:false

let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'
let g:signify_sign_show_count = 0

let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.3 } }
let g:fzf_preview_window = []
let g:fzf_buffers_jump = 1

let g:lightline = {
			\ 'colorscheme': 'solarized',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'gitbranch', 'readonly', 'absolutepath', 'modified'] ],
			\   'right': [ [ 'lineinfo' ],
			\              [ 'percent' ],
			\              [ 'filetype'], ['lsp_hints'], ['lsp_warnings'], ['lsp_errors'] ]
			\ },
			\ 'component_function': {
			\   'gitbranch': 'FugitiveHead',
			\   'lsp_errors': 'LspErrors',
			\   'lsp_warnings': 'LspWarnings',
			\   'lsp_hints': 'LspHints',
			\ },
			\ }

let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_zathura_options = '-reuse-instance'
let g:vimtex_imaps_leader = ','
let g:tex_conceal = ''
let g:tex_fast = ''
let g:tex_flavor = 'latex'

let g:startify_custom_header = startify#center(['welcome back, and a fine day it is!'])
let g:startify_files_number = 15
let g:startify_use_env = 1
let g:startify_lists = [
			\ { 'type': 'dir',      'header': ['  Current Directory '. getcwd()] },
			\ { 'type': 'sessions',  'header': ['   Sessions']       },
			\ ]

function LspErrors() abort
	let icon = '❗:'
	let count = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })")
	if count >= 1
		return icon . count
	else
		return ''
	endif
endfunction

function LspWarnings() abort
	let icon = '⚠️ :'
	let count = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })")
	if count >= 1
		return icon . count
	else
		return ''
	endif
endfunction

function LspHints() abort
	let icon = '💡:'
	let count = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })")
	if count >= 1
		return icon . count
	else
		return ''
	endif
endfunction
