" settings for ctrlp fuzzy finder

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'w'

let g:ctrlp_max_files = 0
let g:ctrlp_regexp = 0

let g:ctrlp_reuse_window = 'netrw'

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

" bind ctrl-shift-p -> ctrl-F12 -> CtrlP from home
if has("nvim")
  nnoremap <C-f12> :CtrlP ~/<cr>
else
  nnoremap [24;5~ :CtrlP ~/<cr>
endif

if executable('ag')

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -f --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif
