#!/bin/bash

# fix mirrorlist
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# install k3s
export                                          \
        K3S_KUBECONFIG_MODE="644"               \
        INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_SELINUX="true"                      \
        K3S_CLUSTER_INIT=1                      \
        INSTALL_K3S_EXEC="server                \
            --flannel-iface=eth1                \
            "
        # K3S_TOKEN=$2                            \
        # K3S_SELINUX="false"                     \
            # --cluster-init                      \

curl -sfL https://get.k3s.io | sh -

echo "alias k='kubectl'" >> /etc/bashrc

while ! sudo /usr/local/bin/kubectl --help
do
    sleep 5
done

# /usr/local/bin/kubectl apply -f /vagrant/confs/
sudo /usr/local/bin/kubectl apply -f $3

# https://jmrobles.medium.com/fix-rancher-ssl-certificate-aaa9cb7cc7de
# /usr/local/bin/kubectl --insecure-skip-tls-verify delete secret k3s-serving -n kube-system

# sudo yum install -y vim
# rm /var/lib/rancher/k3s/server/tls/dynamic-cert.json
