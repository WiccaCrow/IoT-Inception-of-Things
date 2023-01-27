#!/bin/bash

sudo cat /etc/hosts | grep "argocd.ru"
if [ $? -eq 1 ]; then
 sudo echo "127.0.0.1 argocd.ru" >> /etc/hosts
fi

#########
# 2. Run
echo -e "\033[1;35m Run \033[0m"

echo -e "\033[32m cluster create \033[0m"
k3d cluster create mmCluster                                  \
                                --api-port 6550               \
                                --port 443:443@loadbalancer   \
                                --port 80:80@loadbalancer     \

kubectl wait --for=condition=Ready=true nodes --all --timeout=-1s

echo -e "\033[32m manifests \033[0m"
kubectl create           -f ../confs/dev/

timecount=0
while ! kubectl wait --for=condition=Ready=true pods --all -n dev
do
    echo -e "\033[36m...$timecount s. Please wait while resources are created (dev) \033[0m"
    sleep 5
    let timecount+=1
done

# # # kubectl apply  -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl create           -f ../confs/argocd/namespace.yaml
kubectl apply  -n argocd -f ../confs/argocd/argocd_init.yaml
kubectl apply  -n argocd -f ../confs/argocd/ingress.yaml
kubectl apply  -n argocd -f ../confs/argocd/argocd.yaml

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
    let timecount+=5
    echo -e "\033[36m...$timecount s...please wait while password is created\033[0m"
done

echo -e "\033[32m\n    In a browser go to\033[34m \nhttp://argocd.ru:80 \033[32m \n\
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
