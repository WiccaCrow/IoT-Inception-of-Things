#!/bin/bash

#########
# 1. k3d requirements: docker and kubectl

# install Docker
echo -e "\033[1;35m install docker: \033[0m"

echo -e "\033[32m install docker: uninstall old versions \033[0m"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo -e "\033[32m install docker: set up the repository \033[0m"
sudo apt-get update
sudo apt-get install -y \
    ca-certificates     \
    curl                \
    gnupg               \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "\033[32m install docker: Install Docker Engine \033[0m"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# install k3d and kubectl
echo -e "\033[1;35m install k3d \033[0m"
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo -e "\033[1;35m install kubectl \033[0m"
sudo snap install kubectl --classic

#########
# 2. Run
echo -e "\033[1;35m Run \033[0m"

echo -e "\033[32m cluster create \033[0m"
k3d cluster create mmCluster                                \
                                --api-port 6550             \
                                --port '80:80@loadbalancer'
                                # --servers 1                 \

echo -e "\033[32m manifests \033[0m"
kubectl create -f ../confs/namespace.yaml
kubectl apply  -n dev    -f ../confs/dev
kubectl apply  -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo -e "\033[32m manifest argocd \033[0m"
kubectl apply  -n argocd -f ../confs/argocd

# k3d cluster list
# k3d cluster delete mmCluster
