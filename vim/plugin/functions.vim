"" ------------------------
"" --- custom functions ---
"" ------------------------

"" this file is to be saved into ~/.vim/plugin/

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
cabbrev jq call Jq()


" T2S and S2T
function! T2S ()
	set expandtab | %retab! | w
endfunction
cabbrev t2s silent! call T2S()


function! S2T ()
	set noexpandtab | %retab! | w
endfunction
cabbrev s2t silent! call S2T()


" installation of plugins 
function! Install()
	silent execute 'w | so% | PlugInstall | PlugUpdate'
endfunction
cabbrev inst silent! call Install()


" replace entire content of file
function! ReplaceFile()
	silent execute 'norm gg"_dGP'
endfunction
cabbrev rf silent! call ReplaceFile()


" instruct Rg not to include file names in the results 
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

