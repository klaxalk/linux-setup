" config for vim-clang-format
" https://clangformat.com/

let g:clang_format#style_options = {
      \ 'Standard' : 'C++11',
      \ 'BasedOnStyle' : 'Google',
      \ 'AccessModifierOffset' : -2,
      \ 'ColumnLimit' : 160,
      \ 'MaxEmptyLinesToKeep' : 2,
      \ 'AlignAfterOpenBracket' : 'Align',
      \ 'AllowShortLoopsOnASingleLine' : 'false',
      \ 'AllowShortBlocksOnASingleLine' : 'false',
      \ 'AllowShortFunctionsOnASingleLine' : 'false',
      \ 'AllowShortCaseLabelsOnASingleLine' : 'false',
      \ 'AllowShortIfStatementsOnASingleLine' : 'false',
      \ 'AlwaysBreakTemplateDeclarations' : 'true',
      \ 'AlignConsecutiveAssignments' : 'true',
      \ 'SpaceBeforeParens' : 'ControlStatements',
      \ 'BreakBeforeBinaryOperators' : 'false',
      \ 'KeepEmptyLinesAtTheStartOfBlocks' : 'true',
      \ 'BreakBeforeBraces' : 'Custom',
      \ 'SortIncludes' : 'false',
      \ 'BraceWrapping' : {
      \   'AfterClass' :      'false',
      \   'AfterControlStatement' : 'false',
      \   'AfterEnum' :       'true',
      \   'AfterFunction' :   'false',
      \   'AfterNamespace' :  'true',
      \   'AfterObjCDeclaration' : 'true',
      \   'AfterStruct' :     'true',
      \   'AfterUnion' :      'true',
      \   'BeforeCatch' :     'true',
      \   'BeforeElse' :      'false',
      \   'IndentBraces' :    'false'
      \   },
      \ 'AlignConsecutiveDeclarations' : 'true' }

autocmd FileType c,cpp,objc nnoremap <silent> <leader>g A //<reformat_checkpoint><esc>:ClangFormat<cr>gg/reformat_checkpoint<cr>daW:%s/\s\+$//g<cr>/asd<cr>zt
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
