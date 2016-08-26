#!/bin/bash   

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

echo '
parse_git_branch() {
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
}
export PS1="\u \W\[\033[36m\]\$(parse_git_branch)\[\033[00m\] $ "

cd ~/Code

' >> ~/.bashrc

mkdir ~/Code

echo '
Status:
'
cat /tmp/status.txt
echo '
=====================

Run: source ~/.bashrc

=====================
'
