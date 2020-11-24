" comment on/off blocks in visual mode 
vnoremap c+ :norm I"<ESC>
vnoremap c- :norm ^x<ESC>

autocmd BufWritePost <buffer> nested source % 
