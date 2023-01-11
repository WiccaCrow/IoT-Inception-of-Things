#!/bin/bash

#
echo -e "\033[1;35m fix mirrorlist \033[0m"
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

#
echo -e "\033[1;35m install k3s \033[0m"
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

#
echo -e "\033[1;35m Create an alias \033[0m"
echo "alias k='kubectl'" >> /etc/bashrc

#
echo -e "\033[1;35m Wait server node \033[0m"
/usr/local/bin/kubectl wait --for=condition=Ready=true nodes --all --timeout=-1s
# NODE_NAME=$(echo $3 | tr '[:upper:]' '[:lower:]')
# /usr/local/bin/kubectl wait --for=condition=Ready=true node $NODE_NAME
echo -e "\033[1;35m server node Ready! \033[0m"
