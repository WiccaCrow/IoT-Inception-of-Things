#!/bin/sh

# for yum in CentOS-8
# https://forketyfork.medium.com/centos-8-no-urls-in-mirrorlist-error-3f87c3466faa
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

echo "192.168.56.110 mdulcieS" >> /etc/hosts
# install k3s
# curl -sfL htt/      

# curl -sfL https://get.k3s.io |               \
     # K3S_KUBECONFIG_MODE="644"               \
     # K3S_URL="https://192.168.56.110:6443"     sh -
     # K3S_TOKEN=mynodetoken                   \
     # sh -
