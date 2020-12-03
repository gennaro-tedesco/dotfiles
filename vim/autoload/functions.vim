"" ------------------------
"" --- custom functions ---
"" ------------------------

" convert list of items to SQL tuple
function! ToTupleFun() range
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
function! Jq ()
	if (&filetype==?'json' || &filetype==?'')
		silent execute '%! jq .'
	else
		echo 'not a json filetype'
	endif
endfunction


" T2S and S2T
function! T2S ()
	set expandtab | %retab! | w
endfunction


function! S2T ()
	set noexpandtab | %retab! | w
endfunction


" installation of plugins 
function! Install()
	silent execute 'w | so% | PlugClean | PlugInstall | PlugUpdate'
endfunction


" replace entire content of file
function! ReplaceFile()
	silent execute 'norm gg"_dGP'
endfunction

