#!/bin/sh

gsettings set org.gnome.desktop.session idle-delay 0
sudo snap install --classic code
sudo apt-get install -y vagrant docker.io virtualbox git
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
sudo echo "192.168.56.110 app2.com app1.com" >> /etc/hosts
sudo echo "127.0.0.1 argocd.ru mygitlab.ru " >> /etc/hosts


