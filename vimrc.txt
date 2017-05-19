syntax enable
filetype indent plugin on
set background=dark
set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2
filetype indent on
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command WQ :execute ':W' | :q
command Wq :Wq
command Q :q
