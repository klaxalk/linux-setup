let g:neomake_open_list = 2
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
autocmd BufWritePost *.cpp,*.hpp,*h,*.cc,*.hh :Neomake!
" call neomake#configure#automake('nrw', 500)
