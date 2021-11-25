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


" convert list of items to SQL tuple
function! functions#ToTupleFun() range
	silent execute a:firstline . ',' . a:lastline . 'norm I"'
	silent execute a:firstline . ',' . a:lastline . 'norm A",'
	silent execute a:firstline . ',' . a:lastline . 'join'

	" lines are now joined, there is only one line
	silent execute 'norm $x'
	silent execute 'norm I('
	silent execute 'norm A)'

	" yank final text
	silent execute 'norm yy'
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


" blink word under cursor
function! functions#BlinkWord(blinktime)
	let target_pat = '\c\%#'.@/
	let ring = matchadd('IncSearch', target_pat)
	redraw
	exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
	call matchdelete(ring)
	redraw
endfunction

function! functions#ToggleQF() abort
	for i in range(1, winnr('$'))
        if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
            cclose
            return
        endif
    endfor

	copen
endfunction

function! functions#ToggleLL() abort
	for i in range(1, winnr('$'))
        if getbufvar(winbufnr(i), '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor

	lopen
endfunction
