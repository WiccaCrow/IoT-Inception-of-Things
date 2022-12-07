#!/bin/bash

# fix mirrorlist
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# install k3s
export    K3S_KUBECONFIG_MODE="644"     \
          K3S_URL=https://$1:6443       \
          K3S_TOKEN=$2

curl -sfL https://get.k3s.io | sh -

# Create an alias forever
echo "alias k='kubectl'" >> /etc/bashrc