#!/bin/bash

#
echo -e "\033[1;35m fix mirrorlist \033[0m"
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

#
swapoff -a
echo -e "\033[1;35m install k3s \033[0m"
export                                          \
        K3S_KUBECONFIG_MODE="644"               \
        INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_SELINUX="true"                      \
        K3S_CLUSTER_INIT=1                      \
        INSTALL_K3S_EXEC="server                \
            --flannel-iface=eth1                \
            "

curl -sfL https://get.k3s.io | sh -

echo "alias k='kubectl'" >> /etc/bashrc

#
echo -e "\033[1;35m kubectl: readiness check \033[0m"
while ! sudo /usr/local/bin/kubectl --help
do
    sleep 5
done

#
echo -e "\033[1;35m manifests \033[0m"
/usr/local/bin/kubectl apply -f /vagrant/confs/app1.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app2.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/app3.yaml
/usr/local/bin/kubectl apply -f /vagrant/confs/ingress.yaml
# /usr/local/bin/kubectl apply -f /vagrant/confs/
# sudo /usr/local/bin/kubectl apply -f $3
