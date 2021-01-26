" comment on/off blocks in visual mode
vnoremap c+ :norm 0i--<ESC>
vnoremap c- :norm 0xx<ESC>

setlocal shiftwidth=3
setlocal softtabstop=3

augroup TRIM_WHITESPACE
	autocmd! * <buffer>
	autocmd BufWritePre <buffer> nested call functions#TrimWhitespace()
augroup END
