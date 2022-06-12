"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
"                                                                              "
"                       __   _ _ _ __ ___  _ __ ___                            "
"                       \ \ / / | '_ ` _ \| '__/ __|                           "
"                        \ V /| | | | | | | | | (__                            "
"                         \_/ |_|_| |_| |_|_|  \___|                           "
"                                                                              "
"                                                                              "
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


set langmenu=en_US                          " set to English menu
let $LANG = 'en_US'

set number	" Show line numbers
set linebreak	" Break lines at word (requires Wrap lines)

set rtp^="/home/azathoth/.opam/cs164/share/ocp-indent/vim"

:filetype plugin on
:filetype indent on
:syntax on " syntax enable

"""""""""""""""""""""""""""""""""""""""""""""
" Fixes mouse issues using Alacritty terminal
"""""""""""""""""""""""""""""""""""""""""""""
set ttymouse=sgr
