#!/bin/bash

date=$(date '+%Y-%m-%d--%H-%M-%S')

echo "Creating .custom-preferences.vim file"
touch ./.vim/custom-preferences.vim

echo "Do you want to clone vim plugins? (y/n)"
read
if [[ $REPLY == 'y' ]]
then
  source ./install-vim-plugins.sh
fi

echo ""
echo "----------"

echo "Do you want to create an undo history folder in .vim/ ? (y/n)"
read
if [[ $REPLY == 'y' ]]
then
  mkdir ./.vim/undo
fi

echo ""
echo "----------"

echo "Do you want to clone tmux clipboard plugin? (y/n)"
read
if [[ $REPLY == 'y' ]]
then
  git clone https://github.com/tmux-plugins/tmux-yank.git .tmux/tmux-yank
fi
echo ""
echo "----------"

function check_file () {
  if [[ -f /home/$USER/$1 ]]
  then
    echo ""
    echo "A $1 file already exists... would you like to create a bk and replace it? (y/n)"
    read
    if [[ $REPLY == "y" ]]
    then
      mv /home/$USER/$1 /home/$USER/$1.$date.bk
      ln -s $PWD/$1 /home/$USER/$1
      echo ""
      echo "$1 updated"
      echo ""
      echo "----------"
    else
      echo ""
      echo "$1 not changed"
      echo ""
      echo "----------"
    fi
  else
    echo ""
    echo "$1 updated"
    echo ""
    echo "----------"
    ln -s $PWD/$1 /home/$USER/$1
  fi
}

check_file ".vimrc"
check_file ".tmux.conf"
check_file ".git-shortcuts.bash"
check_file ".npm-shortcuts.bash"
check_file ".bashrc"
check_file ".profile"
check_file ".vim"
check_file ".tmux"

echo "Do you want to install coc.nvim dependencies (tsserver, json, html, css)? (y/n)"
read
if [[ $REPLY == 'y' ]]
then
# Install extensions for coc.nvim
  mkdir -p ~/.config/coc/extensions
  cd ~/.config/coc/extensions
  if [ ! -f package.json ]
  then
    echo '{"dependencies":{}}'> package.json
  fi
# Change extension names to the extensions you need
  npm install coc-tsserver coc-json coc-html coc-css --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
fi

cd ~/.vim/bundle/coc.nvim

echo ""
echo "----------"

echo "Do you want to install fzf? (y/n)"
read
if [[ $REPLY == 'y' ]]
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

echo ""
echo "----------"

echo ""
echo "DONE"
echo ""

