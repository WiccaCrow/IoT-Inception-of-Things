# Скрипт для запуска

p2/sripts/runS.sh

```
#!/bin/bash

# fix mirrorlist
sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# install k3s
export  INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_SELINUX="true"                      \
        K3S_KUBECONFIG_MODE="644"               \
        K3S_CLUSTER_INIT=1                      \
        INSTALL_K3S_EXEC="server                \
            --flannel-iface=eth1                \
            "

sudo curl -sfL https://get.k3s.io | sh -

echo "alias k='kubectl'" >> /etc/bashrc

while ! /usr/local/bin/kubectl --help
do
    sleep 5
done

/usr/local/bin/kubectl apply -k $2
```


```
#!/bin/bash

# fix mirrorlist                            1.
...

# install k3s                               2.
export  INSTALL_K3S_SELINUX_WARN="true"   \
        K3S_SELINUX="true"                \
        K3S_KUBECONFIG_MODE="644"         \
        K3S_CLUSTER_INIT=1                \
        INSTALL_K3S_EXEC="server          \
            --flannel-iface=eth1          \ 3.
            "

sudo curl -sfL https://get.k3s.io | sh -    4.

echo "alias k='kubectl'" >> /etc/bashrc

while ! /usr/local/bin/kubectl --help       5.
do
    sleep 5
done

/usr/local/bin/kubectl apply -f $2          6.
```

подробно:

Пункты 1. 2. 4. подробно были рассмотрены при написании первой части проекта в файле p1_description.md.\
В этой части задания отсутствуют переменные и флаги, которые были использованы в первой части для соединения с агентом на виртуальной машине воркера/агента (K3S_AGENT_TOKEN,  --bind-address, --advertise-address), так как здесь только сервер.\
Появился новый флаг --flannel-iface=eth1.
Если запустить сервер без него, но в браузере будет получена 401 "Unauthorized" или 404 ошибка в ответ. Для понимания смысла --flannel-iface=eth1 флага, надо понять, как устроена сеть в kubernetes и k3s, что такое flannel, CNI. Подробнее про flannel и другие поставленные вопросы можно ознакомиться по ссылкам ниже:

## Про сам флаг:
1)  k3s: --flanne-iface=eth1
    k8s: --iface=eth1
    Для чего же менять настройку по умолчанию (у k3s N/A в таблице с флагами по настройке сервера). В официальной документации сказано:
```
Vagrant typically assigns two interfaces to all VMs. The first, for which all hosts are assigned the IP address 10.0.2.15, is for external traffic that gets NATed.

This may lead to problems with flannel, which defaults to the first interface on a host. This leads to all hosts thinking they have the same public IP address. To prevent this, pass the --iface eth1 flag to flannel so that the second interface is chosen.
```
Ссылка на первоисточник:
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/

## eth0, eth1 - что это:
## Пункты 2-5) помогут лучше понять то, что написано в 1)

2)  Про сеть в Kubernetes (Kubernetes - Cluster Networking) 

    Просто и в картинках 1:                         \
https://habr.com/ru/company/flant/blog/346304/      

    Просто и в картинках 2:                         \
https://habr.com/ru/company/flant/blog/521406/      

    Официальная документация k8s 1:                     \
    https://kubernetes.io/docs/concepts/cluster-administration/networking/

    Официальная документация k8s 2:                     \
    https://github.com/kubernetes/design-proposals-archive/blob/main/network/networking.md

    Официальная документация k3s 2:                     \
    https://docs.k3s.io/installation/network-options

3)  Про саму Flannel в качестве CNI
    https://github.com/flannel-io/flannel/blob/master/README.md

    Дополнение Flannel организует сеть в кластере (взаимодействие между подами и нодами)

4)  CNI — интерфейс контейнерной сети
    https://github.com/containernetworking/cni

5)  flannel и аналоги - сравнение и короткое описание каждого.
    https://habr.com/ru/company/flant/blog/332432/


#  Deployment
    https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

    readinessProbe и livenessProbe
    Жизнеспособность и готовность контейнера.
    Если проверка на рабочее состояние приложения внутри контейнера завалена, то контейнер будет перезапущен.
    https://kubernetes.io/ru/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

    minReadySeconds
    https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds

    Просто хороший тон. Оставить метку ответственного за это развертывание.
    annotations:
        IOT/owner: "m&m's"

    securityContext:
        readOnlyRootFilesystem
    Настройка не позволит контейнеру в его собственной файловой системе делать записи и как следствие не позволит воспользоваться уязвимостями в Docker и Kubernetes
    https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

hello kubernetes. Ссылка на приложение и инструкция по использованию
https://hub.docker.com/r/paulbouwer/hello-kubernetes/
https://github.com/paulbouwer/hello-kubernetes/tree/0ec53bfee741ae3bffb5936f1c44138d7d4a3006