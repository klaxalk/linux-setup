" vimtex config

let g:vimtex_view_method = 'zathura'

autocmd FileType tex let b:vimtex_main = 'main.tex'

autocmd FileType tex set cursorline
" autocmd FileType tex highlight cursorline cterm=NONE ctermbg=grey ctermfg=white guibg=darkred guifg=white
