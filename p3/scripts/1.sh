#!/bin/bash

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
kubectl wait --for=condition=Ready=true pods --all -n dev

kubectl apply  -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply  -n argocd -f ../confs/argocd

echo -e "\033[1;35m Argo CD in browser: \033[0m"
kubectl wait --for=condition=Ready=true pods --all -n argocd
# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo -e "\033[32m    In a browser go to http://localhost:8080 \n\
    and log in to the argocd account with \n\
    login: \n\033[34m\
admin \n\
   \033[32m and password: \033[34m"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo -e "\033[0m"

kubectl port-forward svc/argocd-server -n argocd 8080:443

# Some useful commands:
# k3d cluster delete mmCluster
# sudo netstat -ltnp | grep -w ':80'
# sudo kubectl get -n dev all