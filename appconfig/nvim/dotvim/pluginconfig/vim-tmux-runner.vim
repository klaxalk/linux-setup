" settings for vim-tmux-runner

" nnoremap <localleader>tsc :VtrSendCommandToRunner<cr>
nnoremap <localleader>ts :VtrSendLinesToRunner!<cr>
vnoremap <localleader>ts :VtrSendLinesToRunner!<cr>
nnoremap <localleader>ta :VtrAttachToPane<cr>
nnoremap <localleader>to :VtrOpenRunner<cr>
nnoremap <localleader>tk :VtrKillRunner<cr>
nnoremap <localleader>tf :VtrFocusRunner<cr>
nnoremap <localleader>td :VtrDetachRunner<cr>
nnoremap <localleader>tc :VtrClearRunner<cr>
nnoremap <localleader>rf :VtrFlushCommand<cr>
nnoremap <localleader>tsf :VtrSendFile!<cr>

" when using :VtrSendFile, how should be various filetypes executed?
let g:vtr_filetype_runner_overrides = {
      \ 'sh': 'bash {file}',
      \ 'py': 'python {file}',
      \ 'matlab': 'run {file}',
      \ }

" when enabled, breaks the sendfile feature
let g:VtrClearBeforeSend = 0

" in python we want to use this as a compilation in c
au FileType python nnoremap <leader>m :VtrSendFile!<cr>
au FileType python nnoremap <leader>l :VtrSendFile!<cr>
