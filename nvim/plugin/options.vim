"" --------------------------------------------
"" - customisation of default plugins options -
"" --------------------------------------------
let g:AutoPairs = {'(':')', '[':']', '{':'}','`':'`', '```':'```', '"""':'"""'}
let g:AutoPairsShortcutFastWrap = '<C-w>'

let g:floaterm_autoclose = 2
let g:floaterm_keymap_toggle = '<F2>'
let g:floaterm_width = 0.85
let g:floaterm_height = 0.9
let g:floaterm_rootmarkers = ['.git']
let g:floaterm_opener = 'edit'
let g:floaterm_title = ''

let g:rainbow_active = 1

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
			\              [ 'filetype'] ]
			\ },
			\ 'component_function': {
			\   'gitbranch': 'FugitiveHead'
			\ },
			\ }

let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_zathura_options = '-reuse-instance'
let g:vimtex_imaps_leader = ','
let g:tex_conceal = ''
let g:tex_fast = ''
let g:tex_flavor = 'latex'

highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_linters = {
			\ 'python': ['flake8'],
			\ 'lua': ['luacheck'],
			\ 'dockerfile': ['hadolint'],
			\ 'sh': ['shellcheck'],
			\ 'tex': ['lacheck'],
			\ 'vim': ['vint'],
			\ 'go': ['golint'],
			\}
let g:ale_fixers = {
			\ 'python': ['black', 'isort'],
			\ 'lua': ['lua-format', 'trim_whitespace'],
			\ 'json': ['jq'],
			\ 'sh': ['shfmt', 'trim_whitespace'],
			\ 'dockerfile': ['trim_whitespace'],
			\ 'yaml': ['prettier', 'trim_whitespace'],
			\ 'tex': ['latexindent', 'trim_whitespace'],
			\ 'go': ['gofmt', 'goimports', 'trim_whitespace'],
			\}
let g:ale_python_isort_options = '--profile black'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '.'
let g:ale_echo_msg_format = '[%linter%]: %s'

let g:startify_custom_header = startify#center(['welcome back, and a fine day it is!'])
let g:startify_files_number = 15
let g:startify_use_env = 1
let g:startify_lists = [
			\ { 'type': 'dir',      'header': ['  Current Directory '. getcwd()] },
			\ { 'type': 'sessions',  'header': ['   Sessions']       },
			\ ]

let g:fzf_checkout_merge_settings = v:false
let g:fzf_branch_actions = {
			\ 'checkout': {
			\   'prompt': 'Checkout> ',
			\   'execute': 'echo system("{git} checkout {branch}")',
			\   'multiple': v:false,
			\   'keymap': 'enter',
			\   'required': ['branch'],
			\   'confirm': v:false,
			\ },
			\ 'track': {
			\   'prompt': 'Track> ',
			\   'execute': 'echo system("{git} checkout --track {branch}")',
			\   'multiple': v:false,
			\   'keymap': 'ctrl-t',
			\   'required': ['branch'],
			\   'confirm': v:true,
			\ },
			\ 'diff': {
			\   'prompt': 'Diff> ',
			\   'execute': 'Gdiff {branch}',
			\   'multiple': v:false,
			\   'keymap': 'ctrl-f',
			\   'required': ['branch'],
			\   'confirm': v:false,
			\ },
			\ 'delete': {
			\   'prompt': 'Delete> ',
			\   'execute': 'echo system("{git} branch -D {branch}")',
			\   'multiple': v:true,
			\   'keymap': 'ctrl-d',
			\   'required': ['branch'],
			\   'confirm': v:true,
			\ },
			\}

let g:bookmark_center = 1
let g:bookmark_show_toggle_warning = 0
let g:bookmark_show_warning = 0

call wilder#enable_cmdline_enter()
call wilder#set_option('modes', ['/', '?', ':'])

call wilder#set_option('pipeline', [
			\   wilder#branch( 
			\     [
			\       wilder#check({_, x -> empty(x)}),
			\       wilder#history(),
			\     ],
			\     wilder#substitute_pipeline(),
			\     wilder#cmdline_pipeline(),
			\     wilder#vim_search_pipeline(),
			\   ),
			\ ])

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': wilder#popupmenu_renderer({
		\ 'highlighter': wilder#basic_highlighter(),
		\ 'max_height': '20%',
		\ 'max_width': '20%',
      \ }),
      \ '/': wilder#wildmenu_renderer(
      \ wilder#lightline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': ' · ',
      \ })
      \ ),
      \ }))

let g:UltiSnipsExpandTrigger = '<nop>'

let g:python3_host_prog = '/usr/local/bin/python3' 

let g:grepper = {}
let g:grepper = {
    \ 'tools': ['rg', 'git'],
    \ 'dir': 'repo',
	\ 'searchreg': 1,
	\ }

