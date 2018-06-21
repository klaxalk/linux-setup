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

" EPIGEN_ADD_BLOCK_TOMAS {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.html_template = '~/git/notes/template/template.html'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let wiki_2 = {}
" let wiki_2.path = '~/git/uav_core.wiki'
" let wiki_2.html_template = '~/git/notes/template/template.html'
" let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_2.index = 'home'
" let wiki_2.syntax = 'markdown'
" let wiki_2.ext = '.md'
" let wiki_2.custom_wiki2html = '~/git/uav_core.wiki/wiki2html.sh'
" let wiki_2.path_html = '~/git/uav_core.wiki/html/'

" let epigen = {}
" let epigen.path = '~/git/profile_manager'
" let epigen.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let epigen.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let epigen.index = 'README'
" let epigen.syntax = 'markdown'
" let epigen.ext = '.md'
" let epigen.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let epigen.path_html = '~/git/profile_manager/html/'

" let linux_setup_wiki = {}
" let linux_setup_wiki.path = '~/git/linux-setup.wiki'
" let linux_setup_wiki.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let linux_setup_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let linux_setup_wiki.index = 'Home'
" let linux_setup_wiki.syntax = 'markdown'
" let linux_setup_wiki.ext = '.md'
" let linux_setup_wiki.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let linux_setup_wiki.path_html = '~/git/linux-setup.wiki/html/'

" let g:vimwiki_list = [wiki_1, wiki_2, epigen, linux_setup_wiki]

" EPIGEN_ADD_BLOCK_TOMAS }

" EPIGEN_ADD_BLOCK_NICOLAS {

" let wiki_1 = {}
" let wiki_1.path = '~/Repositories/pdoc2018-ctu/coop_LAAS_outdoor_tilthex/Notes'
" let wiki_1.html_template = '~/git/notes/template/template.html'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let g:vimwiki_list = [wiki_1]

" EPIGEN_ADD_BLOCK_NICOLAS }

" EPIGEN_ADD_BLOCK_MATEJ {

" let wiki_notes = {}
" let wiki_notes.path = '~/git/notes'
" let wiki_notes.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let wiki_notes.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_notes.index = 'readme'
" let wiki_notes.syntax = 'markdown'
" let wiki_notes.ext = '.md'
" let wiki_notes.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let wiki_notes.path_html = '~/git/notes/html'

" let wiki_exam = {}
" let wiki_exam.path = '~/git/state_exam'
" let wiki_exam.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let wiki_exam.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_exam.index = 'home'
" let wiki_exam.syntax = 'markdown'
" let wiki_exam.ext = '.md'
" let wiki_exam.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let wiki_exam.path_html = '~/git/.wiki/html/'

" let naki = {}
" let naki.path = '~/git/pr2018-naki_platform'
" let naki.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let naki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let naki.index = 'README'
" let naki.syntax = 'markdown'
" let naki.ext = '.md'
" let naki.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let naki.path_html = '~/git/pr2018-naki_platform/html/'

" let linux_setup_wiki = {}
" let linux_setup_wiki.path = '~/git/linux-setup.wiki'
" let linux_setup_wiki.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let linux_setup_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let linux_setup_wiki.index = 'Home'
" let linux_setup_wiki.syntax = 'markdown'
" let linux_setup_wiki.ext = '.md'
" let linux_setup_wiki.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let linux_setup_wiki.path_html = '~/git/linux-setup.wiki/html/'

" let g:vimwiki_list = [wiki_notes, wiki_exam, naki]

" EPIGEN_ADD_BLOCK_MATEJ }
"
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

" autocmd BufWritePost */notes/* call VimuxRunCommand("cd ~/git/notes; nohup ./save_and_update.sh & exit       ")
" autocmd BufWritePost */notes/* AsyncRun bash -c ~/git/notes/save_and_update.sh

" indention in insert mode
autocmd BufRead */notes/* inoremap > <esc>ma>>`amalla
autocmd BufRead */notes/* inoremap < <esc>ma<<`amaa

nmap <Leader>wah :VimwikiAll2HTML<CR>:Vimwiki2HTMLBrowse<CR>

" autocmd BufRead */notes/* inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("j"))

" :nmap <Leader>wn <Plug>VimwikiNextLink
" :nmap <Leader>wp <Plug>VimwikiPrevLink

" let g:vimwiki_table_mappings = 0

" let g:vimwiki_folding = 'list'
