# I. Настроить и запустить Виртуальную машину с помощью командной строки:
https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-modifyvm.html

1. Подготовка гостевой машины и установка ОС на гостевую машину:

    ```
    #!/bin/sh

    # доступные ОС для установки на машине хосте.
    VBoxManage list ostypes

    #  создать виртуальную машину и зарегистрировать в списке виртуальных машин
    VBoxManage createvm                                     \
                        --name vb_mdulcie                   \
                        --basefolder /Users/mdulcie/goinfre \
                        --ostype Ubuntu_64                  \
                        --register

    # настроить виртуальную машину
    VBoxManage modifyvm        vb_mdulcie                   \
                        --memory 4096                       \
                        --vram 64                           \
                        --cpus 6                            \
                        --pae on                            \
                        --longmode on                       \
                        --apic on                           \
                        --x2apic on                         \
                        --nestedpaging on                   \
                        --nested-hw-virt on                 \
                        --rtcuseutc on                      \
                        --clipboard   bidirectional         \
                        --draganddrop bidirectional         \
                        --graphicscontroller vmsvga

    ##########
    # Создать диски
    # контроллер
    VBoxManage storagectl      vb_mdulcie                   \
                        --name "IDE Controller"             \
                        --add ide

    # жесткий диск
    VBoxManage createmedium                                  \
                        --filename /Users/mdulcie/goinfre/vb_mdulcie/vb_mdulcie.vhd \
                        --variant Fixed                      \
                        --size 20000

    # Присоединить жесткий диск к контроллеру
    VBoxManage storageattach   vb_mdulcie                   \
                        --storagectl "IDE Controller"       \
                        --port 0                            \
                        --device 0                          \
                        --type hdd                          \
                        --medium /Users/mdulcie/goinfre/vb_mdulcie/vb_mdulcie.vhd

    # присоединить установочный образ системы гостевой машины
    VBoxManage storageattach   vb_mdulcie                   \
                        --storagectl "IDE Controller"       \
                        --port 1                            \
                        --device 0                          \
                        --type dvddrive                     \
                        --medium /Users/mdulcie/goinfre/ubuntu-20.04.5-desktop-amd64.iso

    # запустить машину с установочного диска
    VBoxManage modifyvm        vb_mdulcie --boot1 dvd
    VBoxManage startvm         vb_mdulcie --type gui
    ```

2. После того, как ОС будет установлена, выключить, а не перезагрузить Виртуальную машину и
    ```
    # запустить машину без установочного диска
    VBoxManage modifyvm        vb_mdulcie --boot1 none
    VBoxManage startvm         vb_mdulcie --type gui
    ```

Внутри Виртуальной машины выполнить команды, либо запустить скрипт с содержимым:
```
#!/bin/sh

sudo snap install --classic code
sudo apt-get install -y vagrant virtualbox git
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
```


# II. Настроить и запустить Виртуальную машину с помощью графического интерфейса:

1.  Настроить Virtualbox.

    1) это включит возможность перетаскивать файлы и копировать/вставлять текст между хостом и гостевой ОС
        ```
        "Настроить" -> "общие" -> "дополнительно" -> "общий буфер обмена" -> "drag n drop"
        ```
    2) при решении дать ВМ более 4ГБ RAM (может зависать ВМ):
        ```
        "Настроить" -> "система" -> "процессор" -> "Включить PAE/NX"
        ```
    3) Обязательно (вагрант без этого не поднимет вм):
        ```
        "Настроить" -> "система" -> "процессор" -> "Включить Nested VT-x/AMD-V"
        ```
    4) По желанию в Дисплее можно добавить видеопамяти, аудио вход/выход, общую папку и т.д.
    5) Зайти в созданную гостевую машину.

    Доступное описание некоторых опций в настройках \
    https://itandlife.ru/technology/emulation_and_virtualization/virtualbox-setup-and-settings/#:~:text=%D0%92%D0%BA%D0%BB%D1%8E%D1%87%D0%B8%D1%82%D1%8C%20PAE%2FNX%20%E2%80%94%20%D1%80%D0%B5%D0%B6%D0%B8%D0%BC%20%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B,4%20%D0%93%D0%91%2C%20%D0%B0%D0%B4%D1%80%D0%B5%D1%81%D1%83%D0%B5%D0%BC%D1%8B%D1%85%20%D0%BF%D1%80%D0%B8%20%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B8

    Варианты исправления зависания Ubuntu на VirtualBox \
    https://www.dz-techs.com/ru/fix-ubuntu-freezing-virtualbox#:~:text=%D0%9E%D1%82%D0%BA%D0%BB%D1%8E%D1%87%D0%B8%D1%82%D0%B5%203D%2D%D1%83%D1%81%D0%BA%D0%BE%D1%80%D0%B5%D0%BD%D0%B8%D0%B5%2C%20%D1%87%D1%82%D0%BE%D0%B1%D1%8B%20%D1%80%D0%B5%D1%88%D0%B8%D1%82%D1%8C%20%D0%BF%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D1%83%20%D0%B7%D0%B0%D0%B2%D0%B8%D1%81%D0%B0%D0%BD%D0%B8%D1%8F&text=%D0%92%20%D0%BC%D0%B5%D0%BD%D1%8E%20%D1%81%D0%BB%D0%B5%D0%B2%D0%B0%20%D0%B2%20VirtualBox,3D%2D%D1%83%D1%81%D0%BA%D0%BE%D1%80%D0%B5%D0%BD%D0%B8%D0%B5%C2%BB%20%D0%BD%D0%B5%20%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD.

2. Установить выбранную ОС из iso образа на гостевую машину. \
    Проект выполнен на убунту 20.04: \
    https://releases.ubuntu.com/20.04.5/ubuntu-20.04.5-desktop-amd64.iso
    ```
        English -> Install Ubuntu -> English-English -> Minimal installation ->
        erase disk and install Ubuntu -> Continue -> Moscow time ->
        login: mdulcie password: mdulcie comp.name: mdulcieVB Log in authomatically
    ```

3. Установить VScode: 
    sudo snap install --classic code

    установить всё удобное (браузер https://www.google.com/chrome/?platform=linux)...

4. Для взаимодействия с гитхаб:
    В ней установить git:
        sudo apt-get install git

    сгененировать ключ
        ssh-keygen

    выбрать папку: /home/mdulcie/.ssh
    из файла /home/mdulcie/.ssh/id_rsa.pub     добавить ключ на гите

https://help.reg.ru/support/servery-vps/oblachnyye-servery/rabota-s-serverom/kak-ustanovit-i-nastroit-ssh

5.
    sudo apt-get install -y vagrant
    sudo apt-get install -y virtualbox


для проверки ip адреса машины можно использовать ifconfig внутри машины (установить net-tools)

почитать про альтернативу кубернету nomad
https://developer.hashicorp.com/nomad/docs/nomad-vs-kubernetes/alternative