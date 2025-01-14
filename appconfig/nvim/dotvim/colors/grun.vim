" Vim color file
" Maintainer:	Matouš Vrba <vrbamato@fel.cvut.c">
" Last Change:	2018 Dec 10
" A bit modified variant of the 'delek' color scheme.
" Intended to work with dark background and 256 color terminal.

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "grun"

" Normal should come first
hi Normal     guifg=Black  guibg=White ctermbg=233
hi Cursor     guifg=bg     guibg=fg
hi lCursor    guifg=NONE   guibg=Cyan

" Note: we never set 'term' because the defaults for B&W terminals are OK
hi Directory  ctermfg=DarkBlue	   guifg=Blue
hi ErrorMsg   ctermfg=White	   ctermbg=DarkRed  guibg=Red	    guifg=White
hi FoldColumn ctermfg=DarkBlue	   ctermbg=Grey     guibg=Grey	    guifg=DarkBlue
hi Folded     ctermfg=Green	   ctermbg=236  guibg=LightGrey guifg=DarkBlue
hi IncSearch  cterm=reverse	   gui=reverse
hi LineNr     ctermfg=100	   guifg=Brown
hi ModeMsg    cterm=bold	   gui=bold
hi MoreMsg    ctermfg=DarkGreen    gui=bold guifg=SeaGreen
hi NonText    ctermfg=Blue	   gui=bold guifg=gray guibg=white
hi Pmenu      guibg=LightBlue
hi PmenuSel   ctermfg=White	   ctermbg=DarkBlue  guifg=White  guibg=DarkBlue
hi Question   ctermfg=DarkGreen    gui=bold guifg=SeaGreen
hi Search     ctermfg=Black	   ctermbg=82 guibg=Yellow guifg=Black
hi SignColumn ctermbg=Black
hi SpecialKey ctermfg=DarkBlue	   guifg=Blue
hi StatusLine cterm=bold	   ctermbg=blue ctermfg=yellow guibg=gold guifg=blue
hi StatusLineNC	cterm=bold	   ctermbg=blue ctermfg=black  guibg=gold guifg=blue
hi Title      ctermfg=DarkMagenta  gui=bold guifg=Magenta
hi VertSplit  cterm=reverse	   gui=reverse
hi Visual     ctermbg=NONE	   cterm=reverse gui=reverse guifg=Grey guibg=fg
hi VisualNOS  cterm=underline,bold gui=underline,bold
hi WarningMsg ctermfg=DarkRed	   guifg=Red
hi WildMenu   ctermfg=Black	   ctermbg=Yellow    guibg=Yellow guifg=Black

" syntax highlighting
hi Comment    cterm=NONE ctermfg=101     gui=NONE guifg=red2
hi Constant   cterm=NONE ctermfg=DarkGreen   gui=NONE guifg=green3
hi Identifier cterm=NONE ctermfg=DarkCyan    gui=NONE guifg=cyan4
hi PreProc    cterm=NONE ctermfg=200 gui=NONE guifg=magenta3
hi Special    cterm=NONE ctermfg=Red    gui=NONE guifg=deeppink
hi Statement  cterm=bold ctermfg=Blue	     gui=bold guifg=blue
hi Type	      cterm=NONE ctermfg=136	     gui=bold guifg=blue
hi Function	  cterm=NONE ctermfg=68
hi Error  	  cterm=NONE ctermbg=124

" vimdiff highlighting
hi DiffAdd    cterm=NONE ctermbg=52 gui=none guifg=bg guibg=Red
hi DiffDelete cterm=NONE ctermbg=52 gui=none guifg=bg guibg=Red
hi DiffChange cterm=NONE ctermbg=52 gui=none guifg=bg guibg=Red
hi DiffText   cterm=NONE ctermbg=88 gui=none guifg=bg guibg=Red

" vim: sw=2
