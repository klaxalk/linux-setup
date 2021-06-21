" YouCompleteMe vim config
"
" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
let g:ycm_key_list_select_completion   = ['<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

nmap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
nmap <leader>yfw <Plug>(YCMFindSymbolInDocument)
nmap <leader>yr :YcmCompleter RefactorRename i

let g:ycm_python_binary_path = '/usr/bin/python3'

" enable YCM refactoring for C-style languages using clangd
let g:ycm_clangd_args = ['-log=verbose', '-pretty']
" let g:ycm_clangd_args = ['-cross-file-rename']
" Let clangd fully control code completion
" let g:ycm_clangd_uses_ycmd_caching = 1
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = '/usr/bin/clangd'

" make ros and youcompleteme be friends
let g:ycm_semantic_triggers = {
\   'roslaunch' : ['="', '$(', '/'],
\   'rosmsg,rossrv,rosaction' : ['re!^', '/'],
\ }

" will allow youcompleteme to work on vimwiki files
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}

" make backspace work again, ycm have somehow broken it
set backspace=2 " make backspace work like most other apps
set backspace=indent,eol,start

au FileType c,cpp,hpp,h nnoremap <leader>. :YcmCompleter GoTo<cr>

" scrolling in autocomplete menu with j and k, or c-j and c-k
" should work only when the menu has been entered either by tab or arrows
set completeopt+=noinsert
inoremap <expr> j ((pumvisible() && !empty(v:completed_item))?("\<C-n>"):("j"))
inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
inoremap <expr> k ((pumvisible() && !empty(v:completed_item))?("\<C-p>"):("k"))
inoremap <expr> <C-k> ((pumvisible() && !empty(v:completed_item))?("\<C-p>"):("\<C-k>"))

let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/default_ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/'.$ROS_WORKSPACE.'/*']
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1 "default 0

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

function! YcmLocationList()
  let @/ = ''
  if exists('#yll')
    au! yll
    augroup! yll
    let g:ycm_always_populate_location_list = 0 "default 0
    YcmRestartServer
    echo 'YCM location list: OFF'
    return 0
  else
    augroup yll
      au!
      let g:ycm_always_populate_location_list = 1 "default 0
      YcmRestartServer
      echo 'YCM location list: ON'
    augroup end
    return 1
  endif
endfunction
nnoremap <leader>yll :call YcmLocationList()<cr>

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

nnoremap <F5> :YcmForceCompileAndDiagnostics<cr> :lop<cr>

nnoremap <leader>jd :YcmCompleter GoTo<CR>

nnoremap <leader>fix :YcmCompleter FixIt<CR>
