if exists("b:current_syntax")
    finish
endif

syntax keyword todoqTag /@.*/
highlight link todoqTag Identifier

let b:current_syntax = "todoq"
