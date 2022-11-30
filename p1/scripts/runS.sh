#!/bin/sh

# for yum in CentOS-8
# https://forketyfork.medium.com/centos-8-no-urls-in-mirrorlist-error-3f87c3466faa
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# install k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" K3S_KUBECONFIG_MODE="644" sh -
