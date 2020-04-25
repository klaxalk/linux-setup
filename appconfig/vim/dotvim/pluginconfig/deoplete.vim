call deoplete#custom#option('sources', {
      \ '_': ['buffer'],
      \ 'cpp': ['buffer', 'tag'],
      \ 'cc': ['buffer', 'tag'],
      \})

call deoplete#custom#option('auto_complete', v:true)

call deoplete#custom#source('ultisnips', 'rank', 1000)

let deoplete#tag#cache_limit_size = 50000000
let g:deoplete#sources#cpp#standard = 17
let g:deoplete#sources#cpp#definitions = ['-DDEBUG']
let g:deoplete#sources#cpp#ros_user_ws = '~/mrs_workspace'
let g:deoplete#sources#cpp#include_paths =
\   get(g:, "deoplete#sources#cpp#include_paths", [
\   "/usr/local/include",
\   "/usr/include/eigen3",
\   ".",
\   'src',
\   "build",
\   "include",
\   "third_party",
\   'lib',
\   "..",
\   "../src",
\   "../include",
\   "../build",
\   '../lib',
\   "../third_party",
\   "../../src",
\   "../../include",
\   '../../lib',
\   "../../third_party"
\   ])

let g:SuperTabDefaultCompletionType = "<c-n>"

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
