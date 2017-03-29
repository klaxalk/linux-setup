" YouCompleteMe vim config
"
" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
let g:ycm_key_list_select_completion   = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

let g:ycm_python_binary_path = '/usr/bin/python3'

let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"

" make ros and youcompleteme be friends
let g:ycm_semantic_triggers = {
\   'roslaunch' : ['="', '$(', '/'],
\   'rosmsg,rossrv,rosaction' : ['re!^', '/'],
\ }

" make backspace work again, ycm have somehow broken it
set backspace=2 " make backspace work like most other apps
set backspace=indent,eol,start

" scrolling in autocomplete menu with j and k
" should work only when the menu has been entered either by tab or arrows
set completeopt+=noinsert
inoremap <expr> j ((pumvisible() && !empty(v:completed_item))?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible() && !empty(v:completed_item))?("\<C-p>"):("k"))

" inoremap <expr> <tab> ((pumvisible() && !empty(v:completed_item))?("\<C-n>"):("<tab>"))

let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/default_ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/'.$ROS_WORKSPACE.'/*']
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

nnoremap <F5> :YcmForceCompileAndDiagnostics<cr> :lop<cr>

nnoremap <leader>jd :YcmCompleter GoTo<CR>

" Autocommand for completing functions using UltiSnips
function! s:onCompleteDone()
  let abbr = v:completed_item.abbr
  let startIdx = stridx(abbr,"(")
  let endIdx = strridx(abbr,")")
  if endIdx - startIdx > 1
    let argsStr = strpart(abbr, startIdx+1, endIdx - startIdx -1)
    "let argsList = split(argsStr, ",")

    let argsList = []
    let arg = ''
    let countParen = 0
    for i in range(strlen(argsStr))
      if argsStr[i] == ',' && countParen == 0
        call add(argsList, arg)
        let arg = ''
      elseif argsStr[i] == '('
        let countParen += 1
        let arg = arg . argsStr[i]
      elseif argsStr[i] == ')'
        let countParen -= 1
        let arg = arg . argsStr[i]
      else
        let arg = arg . argsStr[i]
      endif
    endfor
    if arg != '' && countParen == 0
      call add(argsList, arg)
    endif
  else
    let argsList = []
  endif

  let snippet = '('
  let c = 1
  for i in argsList
    if c > 1
      let snippet = snippet . ", "
    endif
    " strip space
    let arg = substitute(i, '^\s*\(.\{-}\)\s*$', '\1a', '')
    let snippet = snippet . '${' . c . ":" . arg . '}'
    let c += 1
  endfor
  let snippet = snippet . ')' . "$0"
  return UltiSnips#Anon(snippet)
endfunction

" map the autocommand to "enter"
autocmd VimEnter * imap <expr> <cr>
      \ pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?
      \ (v:completed_item.word != '' && v:completed_item.kind == 'f' ?
      \ "\<C-R>=\<SID>onCompleteDone()\<CR>" : "\<C-y>") : ("<cr>")

" map the autocommand to "l"
autocmd VimEnter * imap <expr> l
      \ pumvisible() && exists('v:completed_item') && !empty(v:completed_item) ?
      \ (v:completed_item.word != '' && v:completed_item.kind == 'f' ?
      \ "\<C-R>=\<SID>onCompleteDone()\<CR>" : "\<C-y>") : ("l")

" let l behave the same as enter in completion menu
" inoremap <expr> l ((pumvisible() && !empty(v:completed_item))?("\<C-y>"):("l"))

