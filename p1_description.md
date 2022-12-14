***
#  I. K3S 

При установке понадобится использование yum (внутри скрипта k3s). При поднятии машин (без правки mirrorlist) вагрантом выходит красное сообщение:

_SW: Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist_

Решается командами ниже.

```
# for yum in CentOS-8
# https://forketyfork.medium.com/centos-8-no-urls-in-mirrorlist-error-3f87c3466faa
# sudo sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
# sudo sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

```
Наши команды для установки k3s в скрипте:

## Server

```
export  INSTALL_K3S_SELINUX_WARN="true"         \
        K3S_SELINUX="true"                      \
        K3S_KUBECONFIG_MODE="644"               \
        K3S_AGENT_TOKEN=$2                      \
        K3S_CLUSTER_INIT=1                      \
        INSTALL_K3S_EXEC="server                \
            --bind-address=$1                   \
            --advertise-address=$1"

sudo curl -sfL https://get.k3s.io | sh -
```

```
export  INSTALL_K3S_SELINUX_WARN=true           \  1.
        K3S_SELINUX="true"                      \  1.
        K3S_KUBECONFIG_MODE="644"               \  2. и 3.
        K3S_AGENT_TOKEN=$2                      \  4.
        K3S_CLUSTER_INIT=1                      \  5.
        INSTALL_K3S_EXEC="server                \  6.
            --bind-address=$1                   \  7.
            --advertise-address=$1              \  8.

sudo curl -sfL https://get.k3s.io | sh -        \  9.
```

подробно:

1. CentOS SELinux
https://docs.k3s.io/advanced#additional-preparation-for-red-hatcentos-enterprise-linux
В скрипте по ссылке описание и пример можно посмотреть
https://get.k3s.io/

2.    Дополнительно можно указать флаги при установке k3s
https://docs.k3s.io/reference/server-config

3.    Обязательно НУЖНО --write-kubeconfig-mode=644
644 значение - это как обычный chmod
https://0to1.nl/post/k3s-kubectl-permission/

4. K3S_TOKEN or K3S_AGENT_TOKEN
https://docs.k3s.io/reference/server-config

5. K3S_CLUSTER_INIT Initialize a new cluster using embedded Etcd
https://docs.k3s.io/reference/server-config

6. INSTALL_K3S_EXEC. флаги и переменные среды при установке k3s
https://docs.k3s.io/reference/env-variables

7. --bind-address
https://docs.k3s.io/reference/server-config
для чего флаг --bind-address (сервер будет слушать на этом ip)
https://denisitpro.wordpress.com/2021/02/19/k8s-configure-bind-address/

8. --advertise-address
IP сервера объявляем всем членам кластера (нашему агенту)
https://docs.k3s.io/reference/server-config

9.    установить k3s
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -
https://www.k3s.io/
Install Script https://docs.k3s.io/quick-start


## Worker

```
export    K3S_KUBECONFIG_MODE="644"     \
          K3S_URL="https://$1:6443"     \
          K3S_TOKEN=$2                  \

curl -sfL https://get.k3s.io | sh -
```
K3S_KUBECONFIG_MODE см.в п.2 и 3 в настройке сервера (выше)

https://docs.k3s.io/quick-start

https://docs.k3s.io/reference/agent-config


## k3s uninstall
Зайти в виртуальную машину сервера/агента и ввести:
```
  # Виртуальная машина сервера
  /usr/local/bin/k3s-uninstall.sh

  # Виртуальная машина агента
  /usr/local/bin/k3s-agent-uninstall.sh
```

***
# II. Vagrant

1. Для написания Vagrantfile можно использовать код на Ruby.
Например, здесь мы сгенерировали токен (12-15 строки):
```
# Generate token
require 'openssl'
require 'digest/md5'
TOKEN = Digest::MD5.hexdigest(OpenSSL::Random.random_bytes(32))

```
2. Рекомендации в задании 1 CPU, 512 MB of RAM (or 1024)
соответствуют требованиям для k3s
https://docs.k3s.io/installation/requirements

3. С целью экономии места, можно задать путь сохранения боксов
https://webhamster.ru/mytetrashare/index/mtb0/1443950715w1w8jn2plh

4. Переменные окружения (VAGRANT_HOME)

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
Отключить параллельную подготовку боксов сервера и воркера
https://developer.hashicorp.com/vagrant/docs/other/environmental-variables

5. 1. Для провайдера Virtualbox.
Настроить Vagrantfile config.vm
https://developer.hashicorp.com/vagrant/docs/vagrantfile/machine_settings

vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
откуда взят флаг --cpuexecutioncap, и подобные
https://www.virtualbox.org/manual/UserManual.html

5. 2. Vagrant with Docker provider: specifying CPU and Memory
https://stackoverflow.com/questions/47919339/vagrant-with-docker-provider-specifying-cpu-and-memory

6. Несколько машин (Сервер и Сервер-воркер)
https://developer.hashicorp.com/vagrant/docs/multi-machine

7. Запуск команд при старте машины (настройки)
provisioning

inline - запуск скрипта, приложения, команды
https://developer.hashicorp.com/vagrant/docs/provisioning/shell

privileged - как суперпользователь

nodeSW.vm.provision "shell",
  path: "scripts/runSW.sh"
когда inline, когда path для скрипта 
(примеры, аргументы, текст скрипта в самом в вагрантафйле)
https://developer.hashicorp.com/vagrant/docs/provisioning/shell#inline-scripts

8. SSH и Vagrant
https://developer.hashicorp.com/vagrant/docs/cli/ssh



***
# III. CentOS 

варианты скачивания ОС
```
1. https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box

2. https://vagrantcloud.com/centos/8
```
1. 
vagrant init -m my-box https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box

это создаст вагрантфайл

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "my-box"
  config.vm.box_url = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box"
end
```
с сайта ОС (1 мин)
https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box

2. 

https://vagrantcloud.com/centos/8
это создаст вагрантфайл

```

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
end
```

через вагрант инит, в вагрантфайле будет строка config.vm.box = "centos/8" 
и произойдет скачивание образа ОС по ссылке https://vagrantcloud.com/centos/8
vagrant init -m centos/8

3. 
локальный файл образа (аналогично п.1 vagrant init -m имя_бокса путь_к_образу)
file://CentOS-8-Vagrant-8.3.2011-20201204.2.x86_64.vagrant-virtualbox.box



