" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" "{ CocCompleteTab()

function! CocCompleteTab()

  if coc#pum#visible()
    return coc#_select_confirm()
  endif

  if coc#expandableOrJumpable()
    return "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
  endif

  return "\<TAB>"

endfunction

" "}

" "{ CocCompleteEnter()

function! CocCompleteEnter()

  if coc#pum#visible()
    return coc#_select_confirm()
  endif

  if coc#expandableOrJumpable()
    return "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
  endif

  return "\<CR>"

endfunction

" "}

" "{ CocCompleteNormal()

function! CocCompleteNormal()

  if coc#pum#visible()
    return coc#_select_confirm()
  endif

  if coc#expandableOrJumpable()
    return "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>"
  endif

  return "\<C-l>"

endfunction

" "}

" "{ CocDown()

function! CocDown()

  if coc#pum#visible()
    return coc#pum#next(1)
  endif

  if CheckBackspace()
    return "\<TAB>"
  endif

  return coc#refresh()

endfunction

" "}

" "{ CocUp()

function! CocUp()

  if coc#pum#visible()
    return coc#pum#prev(1)
  endif

  return "\<C-h>"

endfunction

" "}

" completion using variosu keys
inoremap <silent><expr> <Enter> CocCompleteEnter()
inoremap <silent><expr> <TAB> CocCompleteTab()
" inoremap <silent><expr> <C-l> CocCompleteNormal()

 " motion "down" in the popup menu
inoremap <silent><expr> <C-j> CocDown()

" motion "up" in the popup menu
inoremap <silent><expr><C-k> CocUp()

" motion within snippet
let g:coc_snippet_next = '<C-l>'
let g:coc_snippet_prev = '<C-h>'

map <Leader>u :CocCommand snippets.editSnippets<CR>

" Use <C-j> for select text for visual placeholder of snippet.
vmap <tab> <Plug>(coc-snippets-select)

" Use K to show documentation in preview window
nnoremap <silent> <leader>k :call ShowDocumentation()<CR>
nnoremap <silent> <leader>cd :CocDiagnostics<CR>

" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-l> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
" xmap <tab>  <Plug>(coc-convert-snippet)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" helps it find project root for cpp
autocmd FileType cpp,hpp,h let b:coc_root_patterns = ['build']

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
