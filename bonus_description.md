# Структура бонусов:
1. bonus/scripts/hub.docker.com/* \
   Dockerfile и скрипт для создания образа Gitlab.
2. bonus/scripts/run.sh \
   Скрипт для запуска Gitlab локально. Для целей исполнения задания при запущенной третьей части проекта надо запустить скрипт, и тогда внутри уже готового кластера будет развернут и запущен Gitlab полностью готовый к работе с третьей частью проекта. \
   Также в этом скрипте есть закомментированные строки:
   ```
   echo -e "\033[32m cluster create \033[0m"
   k3d cluster create mmCluster                             \
                                --api-port 6550             \
                                --port '80:80@loadbalancer'
   ```
   Эти строки позволяют создать новый кластер с именем mmCluster и запустить в нем Gitlab. Это может быть полезно при желании/необходимости запустить бонусы отдельно от 3 части проекта (тестирование новых настроек, других образов Gitlab или ознакомление с Gitlab к примеру).

# Gitlab image
Исходные файлы для создания образа лежат в директории bonus/scripts/hub.docker.com/*
Для бонусов был написан Dockerfile с установкой и запуском Gitlab в контейнере и загружен на hub.docker.com.
В образе прописаны следующие настройки в зависимости от tag, например v3:
```
URL адрес    mygitlab.ru        
Порт         80            
Пользователь root             
Пароль       mdulciemhufflep
```

Создан docker образ, добавлен tag, запушен на hub.docker.com:
```
docker image build -t iot-gitlab ./
docker image tag iot-gitlab mdulcie/inception-of-things-42-21-bonus-gitlab:v1
docker image push mdulcie/inception-of-things-42-21-bonus-gitlab:v1
```
# с Github на локальный Gitlab

Перенаправить синхронизацию репозитория с Github на локальный Gitlab:
1. Зайти в аккаунт на локальном Gitlab (можно root, можно создать нового пользователся).
2. Создать репозиторий проекта.
3. Склонировать репозиторий, добавить в него необходимые файлы и запушить.
```
git clone ссылка_клонирования
git add добавляемые_файлы
git commit -m "some commit"
git push
```
4. запустить скрипт синхронизации synch.sh

Готово!

# Some useful commands:
```
# удалить ноду с именем mmCluster
k3d cluster delete mmCluster

# посмотреть, что занимает порт 6550
sudo netstat -ltnp | grep -w ':6550'

# посмотреть всё, что есть в пространстве имен gitlab
sudo kubectl get -n gitlab all

# создать и получить секреты
sudo kubectl create secret tls secret-test-tls     \
   --namespace gitlab                              \
   --key=./ssl_gitlab/tls.key                      \
   --cert=./ssl_gitlab/tls.crt
sudo kubectl get -n gitlab secret -o yaml

# зайти внутрь контейнера в пространстве имен gitlab в поде с именем pods_name
sudo kubectl exec -n gitlab --stdin --tty pods_name -- /bin/bash

# внутри контейнера argocd-server залогиниться
argocd login localhost:8080

```
Для работы с Gitlab посредством терминала:
```
# install gitlab client
wget -O glab.tar.gz https://gitlab.com/gitlab-org/cli/-/releases/v1.24.1/downloads/glab_1.24.1_Linux_x86_64.tar.gz
apt-get install tar
mkdir glab
tar -xvf glab.tar.gz -C glab
rm glab.tar.gz

# use glab
# "--token xxxxx" - you must to create here 
# http://mygitlab.ru/-/profile/personal_access_tokens
./glab/bin/glab auth login --hostname mygitlab.ru --token xxxxx
```
На сайте https://gitlab.com/gitlab-org/cli# представлены все необходимые инструкции для дальнейшего взаимодействия с аккаунтом на mygitlab.ru через терминал.
Для выполнения бонусной части задания это не является обязательным, поэтому данный фрагмент был представлен, чтобы в ознакомиться с такой возможностью.
