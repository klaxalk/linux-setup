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

let mbzirc_wiki = {}
let mbzirc_wiki.path = '~/git/mbzirc2020/wiki'
let mbzirc_wiki.html_template = '~/git/notes/template/template.html'
let mbzirc_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
let mbzirc_wiki.index = 'README'
let mbzirc_wiki.syntax = 'markdown'
let mbzirc_wiki.ext = '.md'
let mbzirc_wiki.custom_wiki2html = '~/git/uav_core.wiki/wiki2html.sh'
let mbzirc_wiki.path_html = '~/git/mbzirc2020/wiki'

" EPIGEN_ADD_BLOCK_TOMAS {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_1.template_default = 'GitHub'
" let wiki_1.template_ext = '.html5'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let wiki_2 = {}
" let wiki_2.path = '~/git/wiki_uav_core'
" let wiki_2.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_2.template_default = 'GitHub'
" let wiki_2.template_ext = '.html5'
" let wiki_2.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_2.index = 'home'
" let wiki_2.syntax = 'markdown'
" let wiki_2.ext = '.md'
" let wiki_2.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let wiki_2.path_html = '~/git/wiki_uav_core/html/'

" let epigen = {}
" let epigen.path = '~/git/epigen'
" let epigen.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let epigen.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let epigen.index = 'README'
" let epigen.syntax = 'markdown'
" let epigen.ext = '.md'
" let epigen.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let epigen.path_html = '~/git/epigen/html/'

" let profile_manager = {}
" let profile_manager.path = '~/git/profile_manager'
" let profile_manager.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let profile_manager.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let profile_manager.index = 'README'
" let profile_manager.syntax = 'markdown'
" let profile_manager.ext = '.md'
" let profile_manager.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let profile_manager.path_html = '~/git/profile_manager/html/'

" let rospix = {}
" let rospix.path = '~/git/rospix/rospix'
" let rospix.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let rospix.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let rospix.index = 'README'
" let rospix.syntax = 'markdown'
" let rospix.ext = '.md'
" let rospix.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let rospix.path_html = '~/git/profile_manager/html/'

" let rospix_utils = {}
" let rospix_utils.path = '~/git/rospix/utils'
" let rospix_utils.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let rospix_utils.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let rospix_utils.index = 'README'
" let rospix_utils.syntax = 'markdown'
" let rospix_utils.ext = '.md'
" let rospix_utils.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let rospix_utils.path_html = '~/git/profile_manager/html/'

" let linux_setup_wiki = {}
" let linux_setup_wiki.path = '~/git/linux-setup.wiki'
" let linux_setup_wiki.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let linux_setup_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let linux_setup_wiki.index = 'Home'
" let linux_setup_wiki.syntax = 'markdown'
" let linux_setup_wiki.ext = '.md'
" let linux_setup_wiki.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let linux_setup_wiki.path_html = '~/git/linux-setup.wiki/html/'

" let i3_layout_manager = {}
" let i3_layout_manager.path = '~/git/i3-layout-manager/'
" let i3_layout_manager.html_template = '~/git/linux-setup/appconfig/vim/vimwiki_templates/default.html'
" let i3_layout_manager.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let i3_layout_manager.index = 'README'
" let i3_layout_manager.syntax = 'markdown'
" let i3_layout_manager.ext = '.md'
" let i3_layout_manager.custom_wiki2html = '~/git/linux-setup/appconfig/vim/vimwiki_templates/wiki2html.sh'
" let i3_layout_manager.path_html = '~/git/i3-layout-manager/html/'

" let g:vimwiki_list = [wiki_1, wiki_2, mbzirc_wiki, epigen, profile_manager, linux_setup_wiki, rospix, rospix_utils, i3_layout_manager]

" EPIGEN_ADD_BLOCK_TOMAS }

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

" let g:vimwiki_list = [wiki_notes, wiki_exam, naki, mbzirc_wiki]

" EPIGEN_ADD_BLOCK_MATEJ }

" EPIGEN_ADD_BLOCK_VOJTA {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_1.template_default = 'GitHub'
" let wiki_1.template_ext = '.html5'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let g:vimwiki_list = [wiki_1]

" EPIGEN_ADD_BLOCK_VOJTA }

" EPIGEN_ADD_BLOCK_DAN {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_1.template_default = 'GitHub'
" let wiki_1.template_ext = '.html5'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let g:vimwiki_list = [wiki_1]

" EPIGEN_ADD_BLOCK_DAN }

" EPIGEN_ADD_BLOCK_PAVEL {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_1.template_default = 'GitHub'
" let wiki_1.template_ext = '.html5'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let wiki_school = {}
" let wiki_school.path = '~/git/notes/school'
" let wiki_school.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_school.template_default = 'GitHub'
" let wiki_school.template_ext = '.html5'
" let wiki_school.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_school.index = 'school'
" let wiki_school.syntax = 'markdown'
" let wiki_school.ext = '.md'
" let wiki_school.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_school.path_html = '~/git/notes/html'

" let wiki_naki = {}
" let wiki_naki.path = '~/git/notes/projects/NAKI'
" let wiki_naki.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_naki.template_default = 'GitHub'
" let wiki_naki.template_ext = '.html5'
" let wiki_naki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_naki.index = 'NAKI'
" let wiki_naki.syntax = 'markdown'
" let wiki_naki.ext = '.md'
" let wiki_naki.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_naki.path_html = '~/git/notes/html'

" let wiki_darpa = {}
" let wiki_darpa.path = '~/git/notes/projects/DARPA'
" let wiki_darpa.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_darpa.template_default = 'GitHub'
" let wiki_darpa.template_ext = '.html5'
" let wiki_darpa.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_darpa.index = 'DARPA'
" let wiki_darpa.syntax = 'markdown'
" let wiki_darpa.ext = '.md'
" let wiki_darpa.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_darpa.path_html = '~/git/notes/html'

" let g:vimwiki_list = [wiki_1, wiki_school, wiki_naki, wiki_darpa]

" " EPIGEN_ADD_BLOCK_DARPA {

" " let wiki_darpa_shared = {}
" " let wiki_darpa_shared.path = '~/git/notes_darpa'
" " let wiki_darpa_shared.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" " let wiki_darpa_shared.template_default = 'GitHub'
" " let wiki_darpa_shared.template_ext = '.html5'
" " let wiki_darpa_shared.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" " let wiki_darpa_shared.index = 'index'
" " let wiki_darpa_shared.syntax = 'markdown'
" " let wiki_darpa_shared.ext = '.md'
" " let wiki_darpa_shared.custom_wiki2html = '~/git/notes_darpa/wiki2html.sh'
" " let wiki_darpa_shared.path_html = '~/git/notes_darpa/html'

" " let g:vimwiki_list = [wiki_1, wiki_school, wiki_naki, wiki_darpa, wiki_darpa_shared]

" " EPIGEN_ADD_BLOCK_DARPA }

" EPIGEN_ADD_BLOCK_PAVEL }

" EPIGEN_ADD_BLOCK_VIT {

" let wiki_1 = {}
" let wiki_1.path = '~/git/notes'
" let wiki_1.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" let wiki_1.template_default = 'GitHub'
" let wiki_1.template_ext = '.html5'
" let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" let wiki_1.index = 'index'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.custom_wiki2html = '~/git/notes/wiki2html.sh'
" let wiki_1.path_html = '~/git/notes/html'

" let g:vimwiki_list = [wiki_1]

" " EPIGEN_ADD_BLOCK_DARPA {

" " let wiki_darpa_shared = {}
" " let wiki_darpa_shared.path = '~/git/notes_darpa'
" " let wiki_darpa_shared.template_path = '~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/'
" " let wiki_darpa_shared.template_default = 'GitHub'
" " let wiki_darpa_shared.template_ext = '.html5'
" " let wiki_darpa_shared.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'bash': 'sh'}
" " let wiki_darpa_shared.index = 'index'
" " let wiki_darpa_shared.syntax = 'markdown'
" " let wiki_darpa_shared.ext = '.md'
" " let wiki_darpa_shared.custom_wiki2html = '~/git/notes_darpa/wiki2html.sh'
" " let wiki_darpa_shared.path_html = '~/git/notes_darpa/html'

" " let g:vimwiki_list = [wiki_1, wiki_darpa_shared]

" " EPIGEN_ADD_BLOCK_DARPA }

" EPIGEN_ADD_BLOCK_VIT }

" EPIGEN_ADD_BLOCK_MATOUS {

" let g:vimwiki_list = [mbzirc_wiki]

" EPIGEN_ADD_BLOCK_MATOUS }

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
