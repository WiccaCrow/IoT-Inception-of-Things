#!/bin/sh

# for yum in CentOS-8
# https://forketyfork.medium.com/centos-8-no-urls-in-mirrorlist-error-3f87c3466faa
# sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
# sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

echo "$1 mdulcieS" >> /etc/hosts

# install k3s
export    K3S_KUBECONFIG_MODE="644"     \
          K3S_TOKEN=$2                  \
          

curl -sfL https://get.k3s.io |          \
     INSTALL_K3S_EXEC="agent            \
          --server https://$1:6443"     \
     sh -s --

# alias k='kubectl'