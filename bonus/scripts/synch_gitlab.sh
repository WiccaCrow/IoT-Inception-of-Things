#!/bin/bash

echo -e "\033[32m add manifests to local Gitlab \033[0m"
rm -r ~/mdulcieforgitlab
git clone http://mygitlab.ru/root/mdulcie.git ~/mdulcieforgitlab
cp -r ../../p3/confs/dev ~/mdulcieforgitlab/
cd ~/mdulcieforgitlab
pwd
mv dev confs
git add .
git status
git commit -m "synch Gitlab"
git push
cd -
rm -r ~/mdulcieforgitlab

echo -e "\033[32m argocd: synchronization with Gitlab \033[0m"
gitlab_pod_url=$(echo $(echo -n $(sudo kubectl get -n gitlab pod -o wide | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')))
sed -i "s/mygitlab.ru/$gitlab_pod_url/g" ../confs/argocd/argocd.yaml 

kubectl apply  -n argocd -f ../confs/argocd/argocd.yaml
echo -e "\033[32m completed! \033[0m"

sed -i "s/$gitlab_pod_url/mygitlab.ru/g" ../confs/argocd/argocd.yaml 
