map <Leader>u :UltiSnipsEdit<CR>

" Show the ultisnips file in a vertical split when we open it with UltiSnipsEdit
let g:UltiSnipsEditSplit="horizontal"
" Just read my snippets directory, don't read the default stuff

let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"

" show tabs
au BufNewFile,BufRead *.snippets set list
au BufNewFile,BufRead *.snippets set listchars=tab:▸▸
