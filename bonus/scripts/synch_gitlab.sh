#!/bin/bash

echo -e "\033[32m add manifests to local Gitlab \033[0m"
git clone http://mygitlab.ru:80/root/mdulcie.git ~/mdulcie
cp -r ../../p3/confs/dev ~/mdulcie/
cd ~/mdulcie
mv dev confs
git add .
git status
git commit -m "synch Gitlab"
git push
cd -

echo -e "\033[32m argocd: synchronization with Gitlab \033[0m"
kubectl apply  -n argocd -f ../confs/argocd
echo -e "\033[32m completed! \033[0m"
