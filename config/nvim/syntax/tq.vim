" Quit when a syntax file was already loaded.
if exists("b:current_syntax") | finish | endif

" Match -> Prefix
syntax match tqTaskState "\v^\s*\[(\w|\s)\]"
syntax match tqTaskTemp "\v^\s*\[(\w|\s)\] ! "
" syntax match tqTaskState "\v^\s*(\w): "
" syntax match tqTaskTemp "\v^\s*(\w): ! "
" syntax match tqTaskState "\v^\s*(\w)\) "
" syntax match tqTaskTemp "\v^\s*(\w)\) ! "

" Match -> Tags
syntax match tqTagName "\v \@(\w|-|\.){1,}"
syntax match tqTagValue "\v \@(\w|-|\.){1,}\((\w|\d|-)*\)"

" Match -> Others
syntax match tqComment "\v^\s*#.*$"
syntax match tqDate "\v\d{4}(-\d{2}){2}"
syntax match tqDateTime "\v\d{4}(-\d{2}){2}\.\d{2}:\d{2}"
syntax match tqHyperlink "\vhttp(s?)://(\w|/|\?|\+|\=|\.|\#|-|\~|\@)*"

" Link the syntax
hi link tqTaskState Constant
hi link tqTaskTemp Boolean
hi link tqTagName Keyword
hi link tqTagValue tqTagName
hi link tqComment Comment
hi link tqDate Operator
hi link tqDateTime tqDate
hi link tqHyperlink Constant

let b:current_syntax = "tq"
