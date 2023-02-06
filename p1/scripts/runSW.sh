#!/bin/bash

#
echo -e "\033[1;35m fix mirrorlist \033[0m"
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

#
swapoff -a
echo -e "\033[1;35m install k3s \033[0m"
export    K3S_KUBECONFIG_MODE="644"     \
          K3S_URL=https://$1:6443       \
          K3S_TOKEN=$2

curl -sfL https://get.k3s.io | sh -

#
echo -e "\033[1;35m Create an alias \033[0m"
echo "alias k='kubectl'" >> /etc/bashrc
