" comment on/off blocks in visual mode 
vnoremap c+ :norm I"<ESC>
vnoremap c- :norm ^x<ESC>

au! BufWritePost <buffer> source % 
