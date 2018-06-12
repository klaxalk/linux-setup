" Quit when a syntax file was already loaded.
if exists('b:current_syntax') | finish |  endif

syntax match vmDollars "\$\zs[^$]\+\ze\$"
syntax match vmComment "#.*$"

hi def link vmDollars Statement
hi def link vmComment Comment

let b:current_syntax = 'epigen'
