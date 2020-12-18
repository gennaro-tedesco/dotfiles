"" ------------------------
"" --- custom functions ---
"" ------------------------

" yank text with line numbers and file name on top
function! functions#CompleteYank()
	redir @n | silent! :'<,'>number | redir END
	let @*=expand("%") . ':' . "\n" . @n
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


" prettify json
function! functions#Jq ()
	if (&filetype==?'json' || &filetype==?'')
		silent execute '%! jq .'
	else
		echo 'not a json filetype'
	endif
endfunction


" T2S and S2T
function! functions#T2S ()
	set expandtab | %retab! | w
endfunction


function! functions#S2T ()
	set noexpandtab | %retab! | w
endfunction


" installation of plugins
function! functions#Install()
	silent execute 'w | so% | PlugInstall | PlugUpdate'
endfunction


" replace entire content of file
function! functions#ReplaceFile()
	silent execute 'norm gg"_dGP'
endfunction

