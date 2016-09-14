#!/bin/bash   

# Run this script by pasting this into a terminal on a fresh new VM
# sudo wget -O - https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision.sh | bash

Status () {
	$1 && echo [OK] $2 >> /tmp/status.txt || echo [Failure] $2 >> /tmp/status.txt
}

DeleteLock () {
sudo rm /var/lib/apt/lists/lock
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
}

cd /tmp

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
DeleteLock
sudo dpkg -i chrome.deb
Status 'sudo apt-get -f install -y' 'Chrome'

wget https://atom.io/download/deb -O atom.deb
DeleteLock
sudo dpkg -i atom.deb
Status 'sudo apt-get -f install -y' 'Atom'

DeleteLock
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
Status 'sudo apt-get install -y mongodb-org' 'MongoDB'
Status 'sudo service mongod start' 'Started MongoDB'
sudo mkdir /data

DeleteLock
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
Status 'sudo apt-get install -y nodejs' 'Node'
DeleteLock

Status 'sudo apt-get install -y build-essential' 'Build Essential (for NPM)'
Status 'sudo npm i -g gulp' 'Gulp'

Status 'apm i minimap' 'Atom: minimap'
Status 'apm i file-icons' 'Atom: file-icons'
Status 'apm i pigments' 'Atom: pigments'
Status 'apm i linter' 'Atom: linter'
Status 'apm i linter-eslint' 'Atom: linter-eslint'
Status 'apm i highlight-selected' 'Atom: highlight-selected'
Status 'apm i minimap-highlight-selected' 'Atom: minimap-highlight-selected'
Status 'apm i autoclose-html' 'Atom: autoclose-html'
Status 'apm i atom-ternjs' 'Atom: atom-ternjs'
Status 'apm i monokai' 'Atom: monokai'


echo '
parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}
export PS1="\u \W\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

cd ~/Code

' >> ~/.bashrc

mkdir ~/Code

email_name=jonathan.verrecchia
email_provider=@gmail.com
git config --global user.email $email_name$email_provider
git config --global user.name "Jonathan Verrecchia"
ssh-keygen -t rsa -b 4096 -C $email_name$email_provider -f /home/verekia/.ssh/id_rsa -N ''
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

clear

echo '
Status:
'
cat /tmp/status.txt
echo '
=====================

Add SSH Key to GitHub:
'
cat ~/.ssh/id_rsa.pub

echo '

Then run:
  source ~/.bashrc
  git clone git@github.com:verekia/<REPO>.git
  cd <REPO>
  npm install

=====================
'

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
  minimap:
    plugins:
      "highlight-selected": true
      "highlight-selectedDecorationsZIndex": 0
  welcome:
    showOnStartup: false
' > ~/.atom/config.cson 

google-chrome --disable-gpu 'http://localhost:8000'&
google-chrome --disable-gpu 'https://github.com/verekia?tab=repositories'&
atom ~/Code --disable-gpu&
