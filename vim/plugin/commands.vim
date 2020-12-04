
command! -range ToTuple <line1>,<line2> call functions#ToTupleFun()

cabbrev jq call Jq()

" tabulations
cabbrev t2s silent! call T2S()
cabbrev s2t silent! call S2T()

cabbrev inst silent! call Install()

cabbrev rf silent! call ReplaceFile()


" instruct Rg not to include file names in the results 
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" shorthand commands for linting and fixing
cabbrev fix silent! ALEFix
cabbrev lint silent! ALEToggle
