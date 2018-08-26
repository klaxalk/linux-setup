" config for vim-clang-format
" https://clangformat.com/

" EPIGEN_DEL_BLOCK_MATOUS {
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
" EPIGEN_DEL_BLOCK_MATOUS }

" EPIGEN_ADD_BLOCK_MATOUS {
" let g:clang_format#style_options = {
"       \ 'Standard' : 'C++11',
"       \ 'BasedOnStyle' : 'Google',
"       \ 'AccessModifierOffset' : -2,
"       \ 'ColumnLimit' : 160,
"       \ 'MaxEmptyLinesToKeep' : 2,
"       \ 'AlignAfterOpenBracket' : 'Align',
"       \ 'AllowShortLoopsOnASingleLine' : 'false',
"       \ 'AllowShortBlocksOnASingleLine' : 'false',
"       \ 'AllowShortFunctionsOnASingleLine' : 'false',
"       \ 'AllowShortCaseLabelsOnASingleLine' : 'false',
"       \ 'AllowShortIfStatementsOnASingleLine' : 'false',
"       \ 'AlwaysBreakTemplateDeclarations' : 'true',
"       \ 'AlignConsecutiveAssignments' : 'false',
"       \ 'AlignConsecutiveDeclarations' : 'false',
"       \ 'SpaceBeforeParens' : 'ControlStatements',
"       \ 'BreakBeforeBinaryOperators' : 'NonAssignment',
"       \ 'KeepEmptyLinesAtTheStartOfBlocks' : 'true',
"       \ 'DerivePointerAlignment' : 'false',
"       \ 'PointerAlignment' : 'Left',
"       \ 'BreakBeforeBraces' : 'Custom',
"       \ 'SortIncludes' : 'false',
"       \ 'BraceWrapping' : {
"       \   'AfterClass' :      'true',
"       \   'AfterControlStatement' : 'true',
"       \   'AfterEnum' :       'true',
"       \   'AfterFunction' :   'true',
"       \   'AfterNamespace' :  'true',
"       \   'AfterObjCDeclaration' : 'true',
"       \   'AfterStruct' :     'true',
"       \   'AfterUnion' :      'true',
"       \   'BeforeCatch' :     'true',
"       \   'BeforeElse' :      'false',
"       \   'IndentBraces' :    'false'
"       \   },
"       \ }
" EPIGEN_ADD_BLOCK_MATOUS }

autocmd FileType c,cpp,objc nnoremap <silent> <leader>g :ClangFormat<cr>:%s/\s\+$//e<cr>

" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>