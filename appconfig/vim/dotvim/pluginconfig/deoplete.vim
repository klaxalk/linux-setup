call deoplete#custom#option('sources', {
      \ '_': ['buffer'],
      \ 'cpp': ['buffer', 'tag'],
      \ 'cc': ['buffer', 'tag'],
      \})

call deoplete#custom#option('auto_complete', v:false)
