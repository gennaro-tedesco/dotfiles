" comment on/off blocks in visual mode
vnoremap c+ :norm 0i%<ESC>
vnoremap c- :norm 0x<ESC>

set conceallevel=0

augroup AUTO_SAVE
	autocmd! * <buffer>
	autocmd TextChanged,TextChangedI <buffer> silent write | echo "written to file"
augroup END
