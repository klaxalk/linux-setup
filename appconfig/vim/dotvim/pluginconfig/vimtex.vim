" vimtex config

let g:vimtex_view_method = 'zathura'

autocmd FileType tex let b:vimtex_main = 'main.tex'

autocmd FileType tex set cursorline
" autocmd FileType tex highlight cursorline cterm=NONE ctermbg=grey ctermfg=white guibg=darkred guifg=white

let g:vimtex_quickfix_open_on_warning = 0

" delete surrounding command
nmap <leader>dsc :delmarks s l e<cr> :normal F\mlf{lmsh%me`sd`lms`ex`s<cr>:delmarks s l e<cr>
