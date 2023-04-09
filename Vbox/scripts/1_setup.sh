#!/bin/bash

ISO_IMAGE_URL="https://releases.ubuntu.com/focal/ubuntu-20.04.5-desktop-amd64.iso"
ISO_IMAGE_NAME="OS_guest.iso"

WORK_FOLDER=$HOME

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    mkdir -p $WORK_FOLDER/vb_mdulcie
    MEMORY=1024
    CPUS=2
    HD_SIZE=30000
    # to see information about VGA: lspci
    # lspci -v -s 00:02.0
    VGA=128
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ls $HOME | grep goinfre ; then
        echo present
    else
        mkdir $WORK_FOLDER/goinfre
    fi
    WORK_FOLDER+="/goinfre"
    MEMORY=8192
    CPUS=6
    HD_SIZE=30000
    VGA=64
else
    echo Oopps
    exit
fi

# доступные ОС для установки на машине хосте.
# VBoxManage list ostypes
if ! VBoxManage list ostypes | grep Ubuntu_64; then
    echo "It is impossible to install Ubuntu_64 on your VBox"
    exit
fi

#  создать виртуальную машину и зарегистрировать в списке виртуальных машин
echo -e "\033[32m Virtual machine: Create and register \033[0m"
VBoxManage createvm                                     \
                    --name vb_mdulcie                   \
                    --basefolder $WORK_FOLDER           \
                    --ostype Ubuntu_64                  \
                    --register

# настроить виртуальную машину
echo -e "\033[32m Virtual machine: setup \033[0m"
VBoxManage modifyvm        vb_mdulcie                   \
                    --memory $MEMORY                    \
                    --vram $VGA                         \
                    --cpus $CPUS                        \
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
echo -e "\033[32m Virtual machine: create controller \033[0m"
VBoxManage storagectl      vb_mdulcie                   \
                    --name "IDE Controller"             \
                    --add ide

# жесткий диск
echo -e "\033[32m Virtual machine: create hard disk \033[0m"
VBoxManage createmedium                                  \
                    --filename $WORK_FOLDER/vb_mdulcie/vb_mdulcie.vhd \
                    --variant Fixed                      \
                    --size $HD_SIZE

# Присоединить жесткий диск к контроллеру
echo -e "\033[32m Virtual machine: attach hard disk to controller \033[0m"
VBoxManage storageattach   vb_mdulcie                   \
                    --storagectl "IDE Controller"       \
                    --port 0                            \
                    --device 0                          \
                    --type hdd                          \
                    --medium $WORK_FOLDER/vb_mdulcie/vb_mdulcie.vhd

# скачать установочный образ системы гостевой машины
echo -e "\033[32m Virtual machine: download the installation \n                  \
image of the guest machine system \033[0m"
curl -o $WORK_FOLDER/$ISO_IMAGE_NAME $ISO_IMAGE_URL

# присоединить установочный образ системы гостевой машины
echo -e "\033[32m Virtual machine: attach   the installation \n                  \
image of the guest machine system \033[0m"
VBoxManage storageattach   vb_mdulcie                   \
                    --storagectl "IDE Controller"       \
                    --port 1                            \
                    --device 0                          \
                    --type dvddrive                     \
                    --medium $WORK_FOLDER/$ISO_IMAGE_NAME

# запустить машину с установочного диска
echo -e "\033[32m Virtual machine: run with the installation \n                  \
image of the guest machine system \033[0m"
VBoxManage modifyvm        vb_mdulcie --boot1 dvd
VBoxManage startvm         vb_mdulcie --type gui
