" vim-startify config

" CUSTOM Startify settings... TODO: finetune!
autocmd User Startified setlocal cursorline

let g:startify_enable_special         = 1
let g:startify_files_number           = 8
let g:startify_relative_path          = 1
let g:startify_change_to_dir          = 1
let g:startify_update_oldfiles        = 1
let g:startify_session_autoload       = 1
let g:startify_session_persistence    = 0
let g:startify_session_delete_buffers = 0

" should not show up in startify
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ 'bundle/.*/doc',
      \ '/data/repo/neovim/runtime/doc',
      \ ]

" bookmarks in startify
let g:startify_bookmarks = [
      \ { 'b': '~/.bashrc' },
      \ { 'v': '~/.vimrc' },
      \ '~/someotherfile',
      \ ]

" the bottom part of the startify
let g:startify_custom_footer =
      \ ['', "   Pes štěká, kočka mňouká.", '']

hi StartifyBracket ctermfg=240
hi StartifyFile    ctermfg=147
hi StartifyFooter  ctermfg=240
hi StartifyHeader  ctermfg=114
hi StartifyNumber  ctermfg=215
hi StartifyPath    ctermfg=245
hi StartifySlash   ctermfg=240
hi StartifySpecial ctermfg=240

" map <leader>s to newtab+startify
map <leader>s :tabnew<cr>:Startify<CR>      " run startify 

" load quotes for startify
source ~/.vim/../startify_quotes.txt

let g:startify_session_before_save = [
    \ 'echo "Cleaning up before saving.."',
    \ 'silent! NERDTreeClose'
    \ ]

let g:startify_sesssion_autoload = 1
