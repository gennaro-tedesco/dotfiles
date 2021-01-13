" comment on/off blocks in visual mode
vnoremap c+ :norm 0i# <ESC>
vnoremap c- :norm 0xx<ESC>

setlocal shiftwidth=4
setlocal tabstop=4

augroup TRAIL_WHITESPACE
	autocmd! * <buffer>
	autocmd BufWritePre <buffer> nested call functions#TrimWhitespace()
augroup END
