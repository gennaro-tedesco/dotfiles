augroup SOURCE_VIM
	autocmd! * <buffer>
	autocmd BufWritePost <buffer> nested source % | redraw | echo "sourced vim file"
augroup END
