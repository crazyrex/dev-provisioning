#!/bin/bash   

# Run this script by pasting this into a terminal on a fresh new VM
# sudo wget -O - https://raw.githubusercontent.com/verekia/dev-provisioning/master/provision.sh | bash

Status () {
	$1 && echo [OK] $2 >> /tmp/status.txt || echo [Failure] $2 >> /tmp/status.txt
}

cd /tmp

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo dpkg -i chrome.deb
Status 'sudo apt-get -f install -y' 'Chrome'
sudo rm /var/lib/dpkg/lock

wget https://atom.io/download/deb -O atom.deb
sudo dpkg -i atom.deb
Status 'sudo apt-get -f install -y' 'Atom'
sudo rm /var/lib/dpkg/lock

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
Status 'sudo apt-get install -y nodejs' 'Node'
sudo rm /var/lib/dpkg/lock

Status 'sudo apt-get install -y build-essential' 'Build Essential (for NPM)'
Status 'sudo npm install -g gulp' 'Gulp'

Status 'apm install minimap' 'Atom: minimap'
Status 'apm install file-icons' 'Atom: file-icons'
Status 'apm install pigments' 'Atom: pigments'
Status 'apm install linter' 'Atom: linter'
Status 'apm install linter-eslint' 'Atom: linter-eslint'
Status 'apm install highlight-selected' 'Atom: highlight-selected'
Status 'apm install minimap-highlight-selected' 'Atom: minimap-highlight-selected'
Status 'apm install autoclose-html' 'Atom: autoclose-html'
Status 'apm install monokai' 'Atom: monokai'

echo '
parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}
export PS1="\u \W\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

cd ~/Code

' >> ~/.bashrc

mkdir ~/Code

clear

echo '
Status:
'
cat /tmp/status.txt
echo '
=====================

Run:
source ~/.bashrc
git clone <REPO>
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
atom ~/Code --disable-gpu&
