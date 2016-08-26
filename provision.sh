#!/bin/bash   

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo dpkg -i chrome.deb || sudo apt-get -f install -y

sudo rm /var/lib/dpkg/lock

wget https://atom.io/download/deb -O atom.deb
sudo dpkg -i atom.deb || sudo apt-get -f install -y

sudo rm /var/lib/dpkg/lock

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo rm /var/lib/dpkg/lock

sudo npm install -g gulp
