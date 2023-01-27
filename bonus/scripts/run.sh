#!/bin/bash

sudo cat /etc/hosts | grep "mygitlab.ru"
if [ $? -eq 1 ]; then
 sudo echo "127.0.0.1 mygitlab.ru" >> /etc/hosts
fi

# echo -e "\033[32m cluster create \033[0m"
# k3d cluster create mmCluster                                \
#                                 --api-port 6550             \
#                                 --port '80:80@loadbalancer'

echo -e "\033[32m manifests \033[0m"
kubectl create -f ../confs/gitlab/

echo -e "\033[32m waiting for gitlab container to run (about 5 minutes) \033[0m"
timecount=0
while ! kubectl wait  -n gitlab --for=condition=Ready=true --timeout=600s pod --all
do
    echo -e "\033[36m...$timecount s. Please wait while resources are created (argocd) \033[0m"
    sleep 5
    let timecount+=1
done

echo -e "\033[32m waiting for gitlab setup - reconfigure (about 10-15 minutes) \033[0m"
apt-get install curl 1>/dev/null
timecount=0
while ! curl mygitlab.ru 2>/dev/null | grep "You are being"
do
    echo -e "\033[36m...$timecount m\033[0m"
    sleep 60
    let timecount+=1
done

echo -e "\033[32m    In a browser go to\033[34m \nhttp://mygitlab.ru:80 \033[32m \n\
    and log in to the argocd account with \n\
    login: \n\033[34m\
root \n\
   \033[32m and password: \033[34m"
echo "mdulciemhufflep"
echo -e "\033[0m"

echo -e "\033[32m completed! \033[0m"
