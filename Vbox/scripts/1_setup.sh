#!/bin/sh

ISO_IMAGE_URL="https://releases.ubuntu.com/focal/ubuntu-20.04.5-desktop-amd64.iso"
ISO_IMAGE_NAME="OS_guest.iso"
WORK_FOLDER="/Users/mdulcie/goinfre"

# доступные ОС для установки на машине хосте.
VBoxManage list ostypes

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
                    --memory 8192                       \
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
echo -e "\033[32m Virtual machine: create controller \033[0m"
VBoxManage storagectl      vb_mdulcie                   \
                    --name "IDE Controller"             \
                    --add ide

# жесткий диск
echo -e "\033[32m Virtual machine: create hard disk \033[0m"
VBoxManage createmedium                                  \
                    --filename $WORK_FOLDER/vb_mdulcie/vb_mdulcie.vhd \
                    --variant Fixed                      \
                    --size 20000

# Присоединить жесткий диск к контроллеру
echo -e "\033[32m Virtual machine: attach hard disk to controller \033[0m"
VBoxManage storageattach   vb_mdulcie                   \
                    --storagectl "IDE Controller"       \
                    --port 0                            \
                    --device 0                          \
                    --type hdd                          \
                    --medium $WORK_FOLDER/vb_mdulcie/vb_mdulcie.vhd

# скачать установочный образ системы гостевой машины
echo -e "\033[32m Virtual machine: download the installation \n image of the guest machine system \033[0m"
curl -o $WORK_FOLDER/$ISO_IMAGE_NAME $ISO_IMAGE_URL

# присоединить установочный образ системы гостевой машины
echo -e "\033[32m Virtual machine: attach   the installation \n image of the guest machine system \033[0m"
VBoxManage storageattach   vb_mdulcie                   \
                    --storagectl "IDE Controller"       \
                    --port 1                            \
                    --device 0                          \
                    --type dvddrive                     \
                    --medium $WORK_FOLDER/$ISO_IMAGE_NAME

# запустить машину с установочного диска
echo -e "\033[32m Virtual machine: run with the installation \n image of the guest machine system \033[0m"
VBoxManage modifyvm        vb_mdulcie --boot1 dvd
VBoxManage startvm         vb_mdulcie --type gui
