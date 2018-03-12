" vimtex config

let g:vimtex_view_method = 'zathura'

" sets the main file for the latex project
autocmd FileType tex let b:vimtex_main = 'main.tex'

autocmd FileType tex set cursorline

" dont bother us with warnings
let g:vimtex_quickfix_open_on_warning = 0

" delete surrounding command
nmap <leader>dsc :delmarks s l e<cr> :normal F\mlf{lmsh%me`sd`lms`ex`s<cr>:delmarks s l e<cr>

" compilation remapping
au BufNewFile,BufRead *.tex map <Leader>m :w<CR>:VimtexCompile<CR>
au BufNewFile,BufRead *.tex map <Leader>. :w<CR>:VimtexView<CR>
au BufNewFile,BufRead *.tex map <Leader>l :ccl<CR>

"  spellchecking
au BufNewFile,BufRead *.tex setlocal spell spelllang=en_us
let g:tex_comment_nospell= 1 " disable spellchecking in comments

" folding
let g:vimtex_fold_enabled = 0
au FileType tex set foldmethod=marker
au FileType tex set foldmarker=%%{,%%}

" might solve some 
" let g:vimtex_indent_enabled = 0

" au FileType tex setlocal fdm=expr
" au FileType tex setlocal foldexpr=vimtex#fold#level(2)
" au FileType tex setlocal foldopen=all

" remap j and k to move in visal a way, handy when wrapping is set on
" au BufNewFile,BufRead *.tex nnoremap j gj
" au BufNewFile,BufRead *.tex nnoremap k gk

" grepping
au FileType tex nmap <leader>lv :lv //g ./**/*.tex<c-f>^f/a

" set it to some high number to prevent syntax highlite problems
au FileType tex set synmaxcol=10000

" let g:vimtex_complete_recursive_bib = 1

" add dictionary for mbzirc-treasure-hunt paper
autocmd BufRead */mbzirc-treasure-hunt/* execute 'setlocal dict+=~/git/mbzirc-treasure-hunt/dictionary.txt'
