" NERDtree config

" turn on nerd tree if no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd h | endif
let NERDTreeQuitOnOpen=0  " close after opening a file

" open new tab and run nerdtree
nmap <leader>t :tabedit<cr>:NERDTreeToggle<cr>

" nerd tree toggle binding
nnoremap <leader>n :NERDTreeToggle<CR>

