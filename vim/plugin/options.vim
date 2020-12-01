"" --------------------------------------------
"" - customisation of default plugins options -
"" --------------------------------------------

let g:indentguides_tabchar = '|'
let g:indentguides_ignorelist = ['help', 'json']

let g:rainbow_active = 1

let g:gitgutter_enabled = 1

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }

let g:calendar_first_day = 'monday'

let g:lightline = {
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'gitbranch', 'readonly', 'filename', 'modified'] ],
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
let g:tex_flavor = 'latex'

let g:jedi#goto_command = 'gd'
let g:jedi#usages_command = 'gu'
let g:jedi#show_call_signatures = 0

highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_linters = {
			\ 'python': ['flake8'], 
			\ 'dockerfile': ['hadolint'], 
			\ 'sh': ['shellcheck'],
			\ 'latex': ['lacheck'],
			\ 'vim': ['vint'],
			\}
let g:ale_fixers = {
			\ 'python': ['yapf'],
			\ 'yaml': ['prettier'],
			\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '.'

let g:startify_custom_header = startify#center(['welcome back, and a fine day it is!'])
let g:startify_files_number = 15
let g:startify_lists = [
			\ { 'type': 'dir', 'header': ['  Current Directory '. getcwd()] },
			\ { 'type': 'files', 'header': ['  Files'] },
			\ ]

let g:ranger_map_keys = 0

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
			\     wilder#substitute_pipeline(),
			\     wilder#cmdline_pipeline(),
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

let g:comfortable_motion_no_default_key_mappings = 1

