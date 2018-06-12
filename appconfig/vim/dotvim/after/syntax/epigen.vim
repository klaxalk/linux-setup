syn match	epigenOpeningMatch	/.\+EPIGEN_.\+(ACTIVE)\+.\+/ containedin=ALL contained
syn match	epigenActiveSubmatch	/ACTIVE/ containedin=ALL,epigenOpeningMatch contained
syn match	epigenAdd	/\<\zsEPIGEN_ADD_.\+\ze\>.*/ containedin=ALL,epigenOpeningMatch contained
syn match	epigenDel	/\<\zsEPIGEN_DEL_.\+\ze\>.*/ containedin=ALL,epigenOpeningMatch contained

hi def link epigenActiveSubmatch Error
hi def link epigenAdd Macro
hi def link epigenDel Constant
