" function! VimwikiLinkHandler(link)
"   try
"     let browser = '/usr/bin/qutebrowser'
"     execute '!"'.browser.'" ' . a:link
"     return 1
"   catch
"     echo "This can happen for a variety of reasons ..."
"   endtry
"   return 0
" endfun

let wiki_1 = {}
let wiki_1.path = '~/git/notes'
let wiki_1.html_template = '~/git/notes/template/template.html'
let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
let wiki_1.index = 'index'
let wiki_1.syntax = 'markdown'
let wiki_1.ext = '.md'
let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
let wiki_1.path_html = '~/git/notes/html'

let wiki_2 = {}
let wiki_2.path = '~/git/uav_core.wiki'
let wiki_2.html_template = '~/git/notes/template/template.html'
let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
let wiki_2.index = 'home'
let wiki_2.syntax = 'markdown'
let wiki_2.ext = '.md'
let wiki_2.custom_wiki2html = '~/git/uav_core.wiki/wiki2html.sh'
let wiki_2.path_html = '~/git/uav_core.wiki/html/'

let g:vimwiki_list = [wiki_1, wiki_2]

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

autocmd BufWritePost */notes/* call VimuxRunCommand("cd ~/git/notes; nohup ./save_and_update.sh & exit")

" indention in insert mode
autocmd BufRead */notes/* inoremap > <esc>lma>>`alli
autocmd BufRead */notes/* inoremap < <esc>lma<<`ahhi

nmap <Leader>wah :VimwikiAll2HTML<CR>

" autocmd BufRead */notes/* inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("j"))

" :nmap <Leader>wn <Plug>VimwikiNextLink
" :nmap <Leader>wp <Plug>VimwikiPrevLink

" let g:vimwiki_table_mappings = 0

" let g:vimwiki_folding = 'list'
