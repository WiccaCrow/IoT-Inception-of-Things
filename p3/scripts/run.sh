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

echo -e "\033[32m manifests \033[0m"
kubectl create -f ../confs/namespace.yaml
kubectl apply  -n dev    -f ../confs/dev/
timecount=0
while ! kubectl wait --for=condition=Ready=true pods --all -n dev
do
    echo -e "\033[36m...$timecount s. Please wait while resources are created (dev) \033[0m"
    sleep 5
    let timecount+=1
done

# kubectl apply  -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply  -n argocd -f ../confs/argocd

#########
echo -e "\033[1;35m Argo CD in browser: \033[0m"

timecount=0
while ! kubectl wait --for=condition=Ready=true pod --all -n argocd
do
    echo -e "\033[36m...$timecount s. Please wait while resources are created (argocd) \033[0m"
    sleep 5
    let timecount+=1
done

timecount=0
while kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo | grep "NotFound" 2>/dev/null
do
    sleep 5
    ((timecount+=5))
    echo -e "\033[36m...$timecount s...please wait while password is created\033[0m"
done

echo -e "\033[32m    In a browser go to http://localhost:8080 \n\
    and log in to the argocd account with \n\
    login: \n\033[34m\
admin \n\
   \033[32m and password: \033[34m"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo -e "\033[0m"

echo -en " login: admin\n password: " > argocd_psswd.txt
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d >> argocd_psswd.txt
echo >> argocd_psswd.txt
# rm argocd_psswd.txt
