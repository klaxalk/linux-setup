let wiki_1 = {}
let wiki_1.path = '~/git/notes'
let wiki_1.html_template = '~/git/notes/template/template.html'
let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
let wiki_1.index = 'index'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'

let g:vimwiki_list = [wiki_1]

function! AutoGitCommit()
  call system('git rev-parse --git-dir > /dev/null 2>&1')
  if v:shell_error
    return
  endif
  call system('git add ' . expand('%:p'))
  call system('git commit -m ' . shellescape('Auto-commit: saved ' . expand('%'), 1))
  call system('git pull')
  call system('git push')
endfun

autocmd BufWritePost */notes/* call VimuxRunCommand("cd ~/git/notes; git add -A; git commit -m \"autocommit\"; gppo; :q")

" :nmap <Leader>wn <Plug>VimwikiNextLink
" :nmap <Leader>wp <Plug>VimwikiPrevLink

" let g:vimwiki_table_mappings = 0

" let g:vimwiki_folding = 'list'
