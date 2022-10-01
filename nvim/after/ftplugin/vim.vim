augroup SOURCE_VIM
	autocmd! * <buffer>
	autocmd BufWritePost <buffer> nested source %
augroup END
