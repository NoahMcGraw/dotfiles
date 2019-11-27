#!/bin/bash
git clone https://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
git clone https://github.com/ctrlpvim/ctrlp.vim.git .vim/bundle/ctrlp.vim
git clone https://github.com/mattn/emmet-vim.git .vim/bundle/emmet-vim
git clone https://github.com/ConradIrwin/vim-bracketed-paste.git .vim/bundle/vim-bracketed-paste
git clone https://github.com/tpope/vim-commentary.git .vim/bundle/vim-commentary
git clone https://github.com/sheerun/vim-polyglot.git .vim/bundle/vim-polyglot
git clone https://github.com/tpope/vim-surround.git .vim/bundle/vim-surround
git clone https://github.com/bronson/vim-trailing-whitespace.git .vim/bundle/vim-trailing-whitespace
git clone https://github.com/tpope/vim-repeat.git .vim/bundle/vim-repeat
git clone https://github.com/airblade/vim-gitgutter.git .vim/bundle/vim-gitgutter
git clone https://github.com/tpope/vim-repeat.git .vim/bundle/vim-repeat

ln -s $PWD/.vimrc /home/$USER/.vimrc
ln -s $PWD/.vim /home/$USER/.vim
ln -s $PWD/.tmux.conf /home/$USER/.tmux.conf
ln -s $PWD/.bashrc /home/$USER/.bashrc
ln -s $PWD/.profile /home/$USER/.profile

