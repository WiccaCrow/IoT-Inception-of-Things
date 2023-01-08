# k3d

Требования:
1. docker для работы самого k3d
Note: k3d v5.x.x requires at least Docker v20.10.5 (runc >= v1.0.0-rc93) to work properly (see #807)
2. kubectl для взаимодействия через терминал с кластерами Kubernetes


install
https://k3d.io/v5.4.6/#install-script :

```
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

## утсановка docker-engine
https://docs.docker.com/engine/install/ubuntu/
```
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
# sudo docker run hello-world
```
чтобы остановить Docker Engine https://docs.docker.com/desktop/faqs/linuxfaqs/#what-is-the-difference-between-docker-desktop-for-linux-and-docker-engine :
```
sudo systemctl stop docker docker.socket containerd
```
отключить Docker Engine и убрать из автозапуска:
```
sudo systemctl disable docker docker.socket containerd
```

## установка kubectl
```
sudo snap install kubectl --classic
```
Также можно воспользоваться инструкцией на официальном сайте
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/