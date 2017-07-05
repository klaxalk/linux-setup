" config for tmuxline - airline tmux extension

let g:tmuxline_powerline_separators = 0
let g:tmuxline_theme = 'zenburn'

let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '',
    \ 'right' : '',
    \ 'right_alt' : '',
    \ 'space' : ' '}

" custom preset with left-justified window list
let g:tmuxline_preset = {
    \'a'       : '#S',
    \'win'     : '#I #W',
    \'cwin'    : '#I #W',
    \'x'       : '#(echo $ROS_MASTER_URI)',
    \'y'       : '%R',
    \'z'       : '#H',
    \'options' : {'status-justify' : 'left'}}
