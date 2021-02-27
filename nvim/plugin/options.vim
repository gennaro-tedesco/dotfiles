"" --------------------------------------------
"" - customisation of default plugins options -
"" --------------------------------------------
let g:floaterm_autoclose = 2
let g:floaterm_keymap_toggle = '<F2>'
let g:floaterm_width = 0.95
let g:floaterm_height = 0.8
let g:floaterm_rootmarkers = ['.git']
let g:floaterm_opener = 'edit'

let g:rainbow_active = 1

let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_change = '~'
let g:signify_sign_show_count = 0

let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.5 } }
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
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:tex_conceal = ''
let g:tex_fast = ''
let g:tex_flavor = 'latex'

highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_linters = {
			\ 'python': ['flake8'],
			\ 'lua': ['luacheck'],
			\ 'dockerfile': ['hadolint'],
			\ 'sh': ['shellcheck'],
			\ 'latex': ['lacheck'],
			\ 'vim': ['vint'],
			\}
let g:ale_fixers = {
			\ 'python': ['yapf'],
			\ 'lua': ['luafmt'],
			\ 'sh': ['trim_whitespace'],
			\ 'dockerfile': ['trim_whitespace'],
			\ 'yaml': ['prettier', 'trim_whitespace'],
			\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '.'
let g:ale_echo_msg_format = '[%linter%]: %s'

let g:startify_custom_header = startify#center(['welcome back, and a fine day it is!'])
let g:startify_files_number = 15
let g:startify_use_env = 1
let g:startify_lists = [
			\ { 'type': 'dir',      'header': ['  Current Directory '. getcwd()] },
			\ { 'type': 'commands', 'header': ['  Quick commands']       },
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

let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabContextDefaultCompletionType = '<c-n>'

let g:bookmark_center = 1
let g:bookmark_show_toggle_warning = 0
let g:bookmark_show_warning = 0

call wilder#enable_cmdline_enter()
call wilder#set_option('modes', ['/', '?', ':'])
let s:hl = 'LightlineMiddle_active'
let s:mode_hl = 'LightlineLeft_active_0'
let s:index_hl = 'LightlineRight_active_0'

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

call wilder#set_option('renderer', wilder#wildmenu_renderer({
			\ 'highlights': {
			\   'default': s:hl,
			\   'selected': s:index_hl,
			\ },
			\ 'apply_highlights': wilder#query_common_subsequence_spans(),
			\ 'separator': ' · ',
			\ 'ellipsis': '...',
			\ 'left': [{'value': [
			\    wilder#condition(
			\      {-> getcmdtype() ==# ':'},
			\      ' COMMAND ',
			\      ' SEARCH ',
			\    ),
			\ ], 'hl': s:mode_hl,},
			\ wilder#separator('', s:mode_hl, s:hl, 'left'), ' ',
			\ ],
			\ 'right': [
			\    ' ', wilder#separator('', s:index_hl, s:hl, 'right'),
			\    wilder#index({'hl': s:index_hl}),
			\ ],
			\ }))

let g:UltiSnipsExpandTrigger = '<nop>'

let g:python3_host_prog = '/usr/local/bin/python3' 

let g:grepper = {}
let g:grepper = {
    \ 'tools': ['rg', 'git'],
    \ 'dir': 'repo',
	\ }

"" --------------------------------------------------
"" ---- customisation of default plugin commands ----
"" --------------------------------------------------

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --hidden -g '!.git/' --color=always --smart-case ".shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': s:find_git_root()}, 'down:70%'), <bang>0)
command! -bang BCommits call fzf#vim#buffer_commits({'options': '--no-preview', 'down':'15'}, <bang>0)
command! -bang Commits call fzf#vim#commits({'options': '--no-preview', 'down':'15'}, <bang>0)
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(s:find_git_root(), <bang>0)
command! -bang -nargs=? -complete=dir Buffers call fzf#vim#buffers()

function! s:find_git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
