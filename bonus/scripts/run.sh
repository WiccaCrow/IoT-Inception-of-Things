#!/bin/bash

# echo -e "\033[32m cluster create \033[0m"
# k3d cluster create mmCluster                                \
#                                 --api-port 6550             \
#                                 --port '80:80@loadbalancer'

echo -e "\033[32m manifests \033[0m"
kubectl create -f ../confs/gitlab/namespace.yaml
kubectl apply  -n gitlab -f ../confs/gitlab/

echo -e "\033[32m waiting for gitlab container to run (about 5 minutes) \033[0m"
sleep 20
kubectl wait  -n gitlab --for=condition=Ready=true --timeout=600s pods --all

echo -e "\033[32m waiting for gitlab setup - reconfigure (about 10-15 minutes) \033[0m"
apt-get install curl 1>/dev/null
timecount=0
while ! curl mygitlab.ru 2>/dev/null | grep "You are being"
do
    echo -e "\033[36m...$timecount m\033[0m"
    sleep 60
    let timecount+=1
done

echo -e "\033[32m completed! \033[0m"
