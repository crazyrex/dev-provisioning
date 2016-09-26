# Run this script by pasting this command into a terminal on a fresh new Termux install
# apt update && apt upgrade -y && apt install -y curl && curl https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision-termux.sh | bash

mkdir .tmp
Status () {
	$1 && echo [OK] $2 >> .tmp/status.txt || echo [Failure] $2 >> .tmp/status.txt
}

# Git

Status 'apt install -y git' 'Git'
email_name=jonathan.verrecchia
email_provider=@gmail.com
git config --global user.email $email_name$email_provider
git config --global user.name "Jonathan Verrecchia"
git config --global push.default simple
git config --global core.editor "vim"
echo "
alias gs='git status'
alias gd='git diff'
alias ns='npm start'
alias nt='npm test'

parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}
export PS1="\u \W\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

export GIT_EDITOR=vim
export VISUAL=vim
export EDITOR="$VISUAL"

" > .bash_profile

# Node

Status 'apt install nodejs -y' 'NodeJS'

# VIM

Status 'apt install -y vim' 'VIM'
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
silent! colorscheme monokai

set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = './node_modules/.bin/eslint'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 3
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
" >> ~/.vimrc

echo '
Status:
'
cat .tmp/status.txt
echo '
=====================

Press Volume Up + Q for extra keys
Zoom-in to adjust font size.
Set style to Monokai.

Run: source ~/.bash_profile

After cloning a project that uses git-hooks via git-guppy, change the shebang to:
  #!/data/data/com.termux/files/usr/bin/node

'

vim +PluginInstall +qall 2>~/.tmp/devnull
