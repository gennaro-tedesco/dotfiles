" comment on/off blocks in visual mode
vnoremap c+ :norm 0i%<ESC>
vnoremap c- :norm 0x<ESC>

augroup AUTO_SAVE
	autocmd! * <buffer>
	autocmd TextChanged,TextChangedI <buffer> silent write
augroup END
