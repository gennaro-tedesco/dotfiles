"" ------------------------
"" --- custom functions ---
"" ------------------------

" yank text with line numbers and file name on top
function! functions#CompleteYank()
	redir @n | silent! :'<,'>number | redir END
	let filename=expand("%")
	let decoration=repeat('-', len(filename)+1)
	let @*=decoration . "\n" . filename . ':' . "\n" . decoration . "\n" . @n
endfunction


" trim white spaces
function! functions#TrimWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction


" T2S and S2T
function! functions#T2S ()
	set expandtab | %retab! | w
endfunction


function! functions#S2T ()
	set noexpandtab | %retab! | w
endfunction


" replace entire content of file
function! functions#ReplaceFile()
	silent execute 'norm gg"_dGP'
endfunction


function! functions#ToggleQF() abort
	for i in range(1, winnr('$'))
        if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

	if getqflist() == []
		echo "qf list empty"
		return
	endif
	copen
endfunction


function! functions#ToggleLL() abort
	for i in range(1, winnr('$'))
        if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor

	if getloclist(0) == []
		echo "loc list empty"
		return
	endif
	lopen
endfunction
