let s:small_l='ℓ'

set foldmethod=indent
set nofoldenable
set fml=0

set foldtext=FoldText()
set fillchars=fold:\ 

function! FoldText() abort
  let l:fold_lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  return '» ' . l:fold_lines . ' '
endfunction
