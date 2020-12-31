" comment on/off blocks in visual mode
vnoremap c+ :norm 0i"<ESC>
vnoremap c- :norm 0x<ESC>

augroup SOURCE_VIM
	autocmd! * <buffer>
	autocmd BufWritePost <buffer> nested source % | redraw | echo "sourced vim file"
augroup END
