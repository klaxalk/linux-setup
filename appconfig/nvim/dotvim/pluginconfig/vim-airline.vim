" airline config

" running airline
set laststatus=2					" allow running without splitting

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" used patched fonts with special characters
let g:airline_powerline_fonts = 1
