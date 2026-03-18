runtime! syntax/html.vim
unlet! b:current_syntax

syntax match StardictTabName /^[^\t]\+/
syntax match StardictTabDesc /\t.*/ containedin=ALL

syntax include @StardictHTML syntax/html.vim
syntax region StardictTabHTML start=/<i>/ end=/<\/i>/ keepend containedin=ALL contains=@StardictHTML

highlight default link StardictTabName Identifier
highlight default link StardictTabDesc Normal
highlight default htmlItalic gui=italic cterm=italic

let b:current_syntax = "stardict"
