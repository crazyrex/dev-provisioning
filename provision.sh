#!/bin/bash

# Run this script by pasting this into a terminal on a fresh new VM
# Ubuntu: sudo curl https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision.sh | bash -s ubuntu
# Termux: apt update && apt upgrade -y && apt install -y curl && curl https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision.sh | bash -s termux 

if [ $# -ne 1 ]; then
  echo 'You need to pass one parameter to this script, like: | bash -s [ubuntu|termux]'
  exit 1
fi

if [ $1 != 'termux' ] && [ $1 != 'ubuntu' ]; then
  echo 'This is not a valid parameter. It should be "ubuntu" or "termux"'
  exit 1
fi

if [ $1 = 'ubuntu' ]; then
  is_ubuntu=true
  is_termux=false
fi

if [ $1 = 'termux' ]; then
  is_ubuntu=false
  is_termux=true
fi


mkdir ~/.tmp

install_status () {
  $1 && echo [OK] $2 >> ~/.tmp/status.txt || echo [Failure] $2 >> ~/.tmp/status.txt
}


delete_lock () {
  sudo rm /var/lib/apt/lists/lock
  sudo rm /var/lib/dpkg/lock
  sudo dpkg --configure -a
}

if $is_ubuntu; then
  cd /tmp

  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
  delete_lock
  sudo dpkg -i chrome.deb
  install_status 'sudo apt-get -f install -y' 'Chrome'

  wget https://atom.io/download/deb -O atom.deb
  delete_lock
  sudo dpkg -i atom.deb
  install_status 'sudo apt-get -f install -y' 'Atom'

  delete_lock
  sudo apt-get install -y vim

  delete_lock
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  sudo apt-get update
  install_status 'sudo apt-get install -y mongodb-org' 'MongoDB'
  install_status 'sudo service mongod start' 'Started MongoDB'

  delete_lock
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  install_status 'sudo apt-get install -y nodejs' 'Node'
  delete_lock

  install_status 'sudo apt-get install -y build-essential' 'Build Essential (for NPM)'

  install_status 'apm i minimap' 'Atom: minimap'
  install_status 'apm i file-icons' 'Atom: file-icons'
  install_status 'apm i pigments' 'Atom: pigments'
  install_status 'apm i linter' 'Atom: linter'
  install_status 'apm i linter-eslint' 'Atom: linter-eslint'
  install_status 'apm i highlight-selected' 'Atom: highlight-selected'
  install_status 'apm i minimap-highlight-selected' 'Atom: minimap-highlight-selected'
  install_status 'apm i autoclose-html' 'Atom: autoclose-html'
  install_status 'apm i atom-ternjs' 'Atom: atom-ternjs'
  install_status 'apm i git-plus' 'Atom: git-plus'
  install_status 'apm i git-hide' 'Atom: git-hide'
  install_status 'apm i linter-flow' 'Atom: linter-flow'
  install_status 'apm i monokai' 'Atom: monokai'

  echo '"*":
  "autoclose-html":
    forceInline: [
      "title"
      "h1"
      "h2"
      "h3"
      "h4"
      "h5"
      "h6"
      "li"
      "p"
    ]
  core:
    customFileTypes:
      "source.js": [
        "jsx"
      ]
    openEmptyEditorOnStart: false
    themes: [
      "one-dark-ui"
      "monokai"
    ]
  editor:
    fontSize: 17
    preferredLineLength: 100
    showIndentGuide: true
    showInvisibles: true
    softWrap: true
  "exception-reporting":
    userId: "823c51ef-3832-c8de-dcc7-c51e3c5cfd49"
  "linter-flow":
    executablePath: "node_modules/.bin/flow"
  minimap:
    plugins:
      "highlight-selected": true
      "highlight-selectedDecorationsZIndex": 0
  welcome:
    showOnStartup: false
' > ~/.atom/config.cson
fi

if $is_termux; then
  install_status 'apt install -y git' 'Git'
  install_status 'apt install nodejs -y' 'NodeJS'
  install_status 'apt install -y vim' 'VIM'
fi


# VIM (both)

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

if $is_ubuntu; then
  install_status 'sudo npm i -g yarn' 'Yarn'
fi

if $is_termux; then
  install_status 'npm i -g yarn' 'Yarn'
fi

echo '
parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}
export PS1="\W\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

alias l="ls -lA1"
alias ga="git add"
alias gc="git commit"
alias gch="git checkout"
alias gcl="git clone"
alias gpull="git pull"
alias gpush="git push"
alias gs="git status"
alias gd="git diff"
alias ns="npm start"
alias nt="npm test"
alias nr="npm run"
alias ni="npm install"
alias nid="npm install --save-dev"
alias nis="npm install --save"
alias yi="yarn install"
alias ya="yarn add"
alias yd="yarn add --dev"
alias yg="yarn global add"
alias yu="yarn upgrade"
alias ys="yarn start"
alias yt="yarn test"
alias yr="yarn run"

export GIT_EDITOR=vim
export VISUAL=vim
export EDITOR="$VISUAL"

cd ~/Code

' >> ~/.bashrc

if $is_ubuntu; then
  echo '
alias chrome="google-chrome --disable-gpu http://localhost:8000 &"
alias atom="atom ~/Code --disable-gpu &"
' >> ~/.bashrc
fi

if $is_termux; then
  echo '
source ~/.bashrc
' >> ~/.bash_profile
fi

email_name=jonathan.verrecchia
email_provider=@gmail.com
git config --global user.email $email_name$email_provider
git config --global user.name 'Jonathan Verrecchia'
git config --global push.default simple
git config --global core.editor 'vim'


if $is_ubuntu; then
  ssh-keygen -t rsa -b 4096 -C $email_name$email_provider -f /home/verekia/.ssh/id_rsa -N ''
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
fi

echo '
Status:
'
cat ~/.tmp/status.txt
echo '
====================='


if $is_ubuntu; then
  echo '
Add SSH Key to GitHub:
'
  cat ~/.ssh/id_rsa.pub
fi

if $is_termux; then
  echo '
Press Volume Up + Q for extra keys
Zoom-in to adjust font size.
Set style to Monokai.'
fi


echo '
Then run:
  source ~/.bashrc
  gcl [Github Repo]
  cd <repo>
  ni

=====================
'

if $is_ubuntu; then
  google-chrome --disable-gpu 'http://localhost:8000' &
  google-chrome --disable-gpu 'https://github.com/verekia?tab=repositories' &
  atom ~/Code --disable-gpu &
fi

if $is_termux; then
  echo '
After cloning a project that uses git-hooks via git-guppy, change the shebang to:
  #!/data/data/com.termux/files/usr/bin/node
'
fi

mkdir ~/Code
cd ~/Code

vim +PluginInstall +qall 2>~/.tmp/devnull

