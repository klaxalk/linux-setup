" settings for vim-tmux-runner

" compilation
map <Leader>m :w\|silent make\|redraw!\|cc<CR>
map <Leader>fr :%s///g<left><left>
map <Leader>frl :s///g<left><left>
map <Leader>fa :%s//&/g<left><left>
map <Leader>fal :s//&/g<left><left>

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
nnoremap <localleader>tsf :VtrSendFile<cr>

" when using :VtrSendFile, how should be various filetypes executed?
let g:vtr_filetype_runner_overrides = {
      \ 'sh': 'bash -c {file}',
      \ }
