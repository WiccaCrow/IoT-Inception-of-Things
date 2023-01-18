Для бонусов был написан Dockerfile с установкой и запуском Gitlab в контейнере и загружен на hub.docker.com. \
```
URL адрес    localhost        
Порт         8886             
Пользователь root             
Пароль       mdulciemhufflep
```

Создан docker образ, добавлен tag, запушен на hub.docker.com:
```
docker image build -t iot-gitlab ./
docker image tag iot-gitlab mdulcie/inception-of-things-42-21-bonus-gitlab:v1
docker image push mdulcie/inception-of-things-42-21-bonus-gitlab:v1
```

<!-- Далее созданы файлы для развертывания подотовленного образа Gitlab.
Скрипт bonus_gitlab.sh запускает последовательность действий для:
* развертывания Gitlab локально
* замены синхронизированного репозитория с Github на синхронизацию с репозиторием локального Gitlab -->

Some useful commands:
```
# удалить ноду с именем mmCluster
k3d cluster delete mmCluster

# посмотреть, что занимает порт 6550
sudo netstat -ltnp | grep -w ':6550'

# посмотреть всё, что есть в пространстве имен gitlab
sudo kubectl get -n gitlab all

# зайти внутрь контейнера в поде с именем pods_name
sudo kubectl exec -n gitlab --stdin --tty pods_name -- /bin/bash
```
