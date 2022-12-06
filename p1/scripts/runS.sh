#!/bin/sh

# install k3s
export  INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_KUBECONFIG_MODE="644"               \
        K3S_TOKEN=$2
        # INSTALL_K3S_EXEC="server                \
        #     --selinux                           \
        #     --cluster-init                      \
        #     --bind-address=$1                   \
        #     --advertise-address=$1"

sudo curl -sfL https://get.k3s.io |             \
        INSTALL_K3S_EXEC="server                \
            --selinux                           \
            --cluster-init                      \
            --bind-address=$1                   \
            --advertise-address=$1"             \
        sh -

# alias k='kubectl'