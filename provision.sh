#!/bin/bash   

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo dpkg -i chrome.deb || sudo apt-get -f install -y

wget https://atom.io/download/deb -O atom.deb
sudo dpkg -i atom.deb || sudo apt-get -f install -y
