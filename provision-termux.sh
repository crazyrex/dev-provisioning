# Run this script by pasting this command into a terminal on a fresh new Termux install
# apt update && apt upgrade -y && apt install -y curl && curl https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision-termux.sh | bash

# git config, nvm, Node latest, https://github.com/mtscout6/syntastic-local-eslint.vim/blob/master/README.md
# add aliases like git s for git status

mkdir .tmp
Status () {
	$1 && echo [OK] $2 >> .tmp/status.txt || echo [Failure] $2 >> .tmp/status.txt
}

Status 'apt install -y git' 'Git'
Status 'apt install -y vim' 'VIM'
Status 'apt install nodejs -y' 'NodeJS'

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'

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
" >> ~/.vimrc

Status 'vim +PluginInstall +qall' 'Vundle and Plugins'

echo "
syntax enable
colorscheme monokai
" >> ~/.vimrc

email_name=jonathan.verrecchia
email_provider=@gmail.com
git config --global user.email $email_name$email_provider
git config --global user.name "Jonathan Verrecchia"

echo '
Status:
'
cat .tmp/status.txt
echo '
=====================

Press Volume Up + Q for extra keys

'
