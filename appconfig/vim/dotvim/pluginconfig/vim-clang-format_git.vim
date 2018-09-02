" config for vim-clang-format
" https://clangformat.com/
" let g:clang_format#style_options = {

let g:clang_format_tomas = {
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

let g:clang_format_matous = {
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
      \ 'AlignConsecutiveAssignments' : 'false',
      \ 'AlignConsecutiveDeclarations' : 'false',
      \ 'SpaceBeforeParens' : 'ControlStatements',
      \ 'BreakBeforeBinaryOperators' : 'NonAssignment',
      \ 'KeepEmptyLinesAtTheStartOfBlocks' : 'true',
      \ 'DerivePointerAlignment' : 'false',
      \ 'PointerAlignment' : 'Left',
      \ 'BreakBeforeBraces' : 'Custom',
      \ 'SortIncludes' : 'false',
      \ 'BraceWrapping' : {
      \   'AfterClass' :      'true',
      \   'AfterControlStatement' : 'true',
      \   'AfterEnum' :       'true',
      \   'AfterFunction' :   'true',
      \   'AfterNamespace' :  'true',
      \   'AfterObjCDeclaration' : 'true',
      \   'AfterStruct' :     'true',
      \   'AfterUnion' :      'true',
      \   'BeforeCatch' :     'true',
      \   'BeforeElse' :      'false',
      \   'IndentBraces' :    'false'
      \   },
      \ }

function! SetMatousFormat()
let g:clang_format#style_options = g:clang_format_matous
endfunc

function! SetTomasFormat()
let g:clang_format#style_options = g:clang_format_tomas
endfunc

" this is the default
call SetTomasFormat() " EPIGEN_DEL_LINE_MATOUS
" call SetMatousFormat() " EPIGEN_ADD_LINE_MATOUS

" if the first line of a file constains "MatousFormat", set formatting
" according to Matous
au BufReadPost * if getline(1) =~ "MatousFormat" | call SetMatousFormat() | endif

autocmd FileType c,cpp,objc nnoremap <silent> <leader>g :ClangFormat<cr>:%s/\s\+$//e<cr>

" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
