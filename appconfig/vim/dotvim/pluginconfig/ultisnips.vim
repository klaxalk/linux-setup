map <Leader>u :UltiSnipsEdit<CR>

" Show the ultisnips file in a vertical split when we open it with UltiSnipsEdit
let g:UltiSnipsEditSplit="horizontal"
" Just read my snippets directory, don't read the default stuff

let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"

" key bindings for normal use
if g:normal_mode == "1"
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsListSnippets="<c-l>"
  let g:UltiSnipsJumpForwardTrigger="<s-l>"
  let g:UltiSnipsJumpBackwardTrigger="<s-h>"

endif

" key bindings for athame
if g:normal_mode == "0"
  let g:UltiSnipsExpandTrigger="<s-tab>"
  let g:UltiSnipsJumpForwardTrigger="<s-l>"
  let g:UltiSnipsJumpBackwardTrigger="<s-h>"
endif

" show tabs
au BufNewFile,BufRead *.snippets set list
au BufNewFile,BufRead *.snippets set listchars=tab:▸▸
