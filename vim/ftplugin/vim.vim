" comment on/off blocks in visual mode 
vnoremap c+ :norm 0i"<ESC>
vnoremap c- :norm 0x<ESC>

autocmd BufWritePost <buffer> nested source % 
