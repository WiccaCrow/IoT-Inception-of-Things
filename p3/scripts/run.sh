#!/bin/bash

#########
# k3d requirements: docker and kubectl
# 1. install docker: https://docs.docker.com/engine/install/ubuntu/

# uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# set up the repository
sudo apt-get update
sudo apt-get install    \
    ca-certificates     \
    curl                \
    gnupg               \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#########
# 2. install k3d
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# 3. install kubectl
sudo snap install kubectl --classic

# 4. cluster create
k3d cluster create mmCluster                                \
                                --servers 1                 \
                                # --port '80:80@loadbalancer'
                                # --api-port 127.0.0.1:6445   \

# 5. manifests
/usr/local/bin/kubectl create -f ../confs/namespace.yaml
/usr/local/bin/kubectl apply  -n dev    -k ../confs/dev
/usr/local/bin/kubectl apply  -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
/usr/local/bin/kubectl apply  -n argocd -k ../confs/argocd
