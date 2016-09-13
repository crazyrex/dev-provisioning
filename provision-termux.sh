# apt update
# apt upgrade -y
# apt install -y curl

# Run this script by pasting this into a terminal on a fresh new Termux install
# curl https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision-termux.sh | bash

# git config, nvm, Node latest, https://github.com/mtscout6/syntastic-local-eslint.vim/blob/master/README.md
# add aliases like git s for git status

apt install -y git
apt install -y vim
apt install nodejs -y

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/syntastic'
Plugin 'sickill/vim-monokai'
call vundle#end()
filetype plugin indent on
syntax enable
colorscheme monokai
" >> ~/.vimrc

vim +PluginInstall +qall



echo 'Press Volume Up + Q for extra keys'
