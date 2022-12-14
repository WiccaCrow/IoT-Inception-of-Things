#!/bin/bash

# fix mirrorlist
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# install k3s
export  INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_SELINUX="true"                      \
        K3S_KUBECONFIG_MODE="644"               \
        K3S_AGENT_TOKEN=$2                      \
        K3S_CLUSTER_INIT=1                      \
        INSTALL_K3S_EXEC="server                \
            --bind-address=$1                   \
            --advertise-address=$1              \
            "

sudo curl -sfL https://get.k3s.io | sh -

echo "alias k='kubectl'" >> /etc/bashrc