" *****************
" *** Tag pairs ***
" *****************
syntax region pgnTagName start=/\[/ end=/\]/ contains=pgnTagValue 
syntax region pgnTagValue start=/"/ skip=/\\"/ end=/"/ contained

" ****************
" *** Movetext ***
" ****************
" move number
" - pgn requires 1.e4 or 1...e5
" - pattern: whitespace number whitespace? period? whitespace? ellipsis?
syntax match pgnMoveNumber /\%(^\|\s\)\zs\d\+\%(\_s*\.\{3,4}\|\%(\%(\_s*\.\)\?\%(\_s*\.\{3}\)\?\)\)\ze\%(--\|[^-/]\|\_s\)/
 
" piece
" - fide and pgn do not identify pawn by a letter
syntax match pgnPiece /[KQRBNP♔♕♖♗♘♙♚♛♜♝♞♟]/

" file and/or rank of departure
" - used for disambiguation or in long algebraic notation
syntax match pgnDeparture /\%(ch\)\@!\%(\%([1-8]\)\@1<![a-h][1-8]\?\|[QRBN]\@1<=[1-8]\)\%([-x:]\?[a-h][1-8]\?\%([QRBN=(\/X×+#!?\$]\+\|[:x]\%([^a-h]\|\_s\)\|:\?\%(e\.\?p\.\?\|\%(\%(dbl\|dis\)\.\?\_s*\)\?ch\.\?\|mate\)\|\_s\)\)\@=/

" file or square of arrival
" - the \? after [1-8] allows for unambiguous pawn captures seen in
"   abbreviated algebraic notation, eg, ed for exd6
syntax match pgnArrival /[a-h][1-8]\?\%([QRBN=(\/X×+#!?\$]\+\|[:x]\%([^a-h]\|\_s\)\|:\?\%(e\.\?p\.\?\|\%(\%(dbl\|dis\)\.\?\_s*\)\?ch\.\?\|mate\)\|\_s\)\@=\%(ch\|te\)\@2<!/

" abbreviation
" - fide, pgn, and other commonly used
" - overridden by matches below, eg, promotion, castling
syntax match pgnAbbreviation /[-=()\/:xX×+#]\|\%(\%(0-0\%(-0\)\?\)\|\%(O-O\%(-O\)\?\)\)\|e\.\?p\.\?\|\%(\%(dbl\|dis\)\.\?\_s*\)\?ch\.\?\|mate/

" promotion
" - fide requires new piece to immediately follow arrival square;
"   pgn requires an '=' between arrival square and new piece
syntax match pgnPromotion /\%([a-h][1-8]\?:\?\)\@3<=\%([=/]\?[QRBN]\|([QRBN])\)/

" draw offer
" - required by fide but not part of standard algebraic notation or pgn
syntax match pgnDrawOffer /(=)/

" castling
" - fide requires 0 (zero); pgn requires O (uppercase letter)
syntax match pgnCastling /\%(0-0\%(-0\)\?\)\|\%(O-O\%(-O\)\?\)/

" annotations
" - as used by scid and others
syntax match pgnMoveEvaluation /[!?]\+/

syntax match pgnNovelty /\%(^\|\s\)\zsN\ze\_s/

syntax match pgnPositionEvaluation /\~\|(\@1<!=\%(\%([QRBN]\)\@!\%(\/\?[+∞]\)\?\)\|-\%(-\|\/\)\?+\|+\%(=\|--\?\|\/[=-]\)\|∞/

syntax match pgnDiagram /\%(^\|\s\)\zsD\ze\_s/

syntax match pgnNumericAnnotationGlyph /\$\<\%([0-9]\|[1-9][0-9]\|1[0-9][0-9]\|2[0-4][0-9]\|25[0-5]\)\>/

" variations
" - can be nested; excludes parentheses promotion, draw offer
syntax region pgnVariation start=/\%(([=QRBN])\)\@!(/ end=/)\%(([=QRBN])\)\@3<!/ contains=pgnVariation

" result
" - required by pgn
syntax match pgnResult /1-0\|0-1\|1\/2-1\/2\|½-½\|\*/

" ****************
" *** Comments ***
" ****************
" - cannot be nested
syntax region pgnCommentBlock start=/{/ end=/}/
syntax region pgnCommentSingleLine start=/;/ end=/$/


" "Wow! Look at all the colours, man!"
highlight def link pgnTagName Keyword
highlight def link pgnTagValue String
highlight def link pgnMoveNumber @markup.math
highlight pgnPiece                   gui=underline  guifg=foreground
highlight pgnPromotion               gui=italic     guifg=foreground
highlight def link pgnDrawOffer Comment
highlight def link pgnVariation Comment
highlight def link pgnResult Type
highlight def link pgnCommentBlock Comment
highlight def link pgnCommentSingleLine Comment
