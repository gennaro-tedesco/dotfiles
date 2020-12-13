"" ------------------------
"" --- custom functions ---
"" ------------------------

" trim white spaces
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

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
command! -range ToTuple <line1>,<line2> call ToTupleFun()


" prettify json
function! Jq ()
	if (&filetype==?'json' || &filetype==?'')
		silent execute '%! jq .'
	else
		echo 'not a json filetype'
	endif
endfunction
command! Jq call Jq()


" T2S and S2T
function! T2S ()
	set expandtab | %retab! | w
endfunction
command! TS silent! call T2S()


function! S2T ()
	set noexpandtab | %retab! | w
endfunction
command! ST silent! call S2T()


" installation of plugins
function! Install()
	silent execute 'w | so% | PlugInstall | PlugUpdate'
endfunction
command! Inst silent! call Install()


" replace entire content of file
function! ReplaceFile()
	silent execute 'norm gg"_dGP'
endfunction
command! Rf silent! call ReplaceFile()


" instruct Rg not to include file names in the results
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" shorthand commands for linting and fixing
command! Fix :ALEFix
command! Lint :ALEToggle

