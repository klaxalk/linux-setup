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
au BufNewFile,BufRead *.tex setlocal fdm=expr
au BufNewFile,BufRead *.tex setlocal foldexpr=vimtex#fold#level(0)
au BufNewFile,BufRead *.tex setlocal foldopen=all

" remap j and k to move in visal a way, handy when wrapping is set on
au BufNewFile,BufRead *.tex nnoremap j gj
au BufNewFile,BufRead *.tex nnoremap k gk

" grepiing
au FileType tex nmap <Leader>lv :lv //g ./**/*.tex<c-f>^f/a
