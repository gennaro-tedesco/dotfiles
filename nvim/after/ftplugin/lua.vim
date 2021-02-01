setlocal shiftwidth=3
setlocal softtabstop=3

augroup TRIM_WHITESPACE
	autocmd! * <buffer>
	autocmd BufWritePre <buffer> nested call functions#TrimWhitespace()
augroup END

