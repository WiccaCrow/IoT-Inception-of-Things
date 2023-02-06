#!/bin/sh

ISO_IMAGE_NAME="OS_guest.iso"
WORK_FOLDER="/Users/mdulcie/goinfre"
rm -rf $WORK_FOLDER/$ISO_IMAGE_NAME

# запустить машину без установочного диска

echo -e "\033[32m Virtual machine: run without the installation \n                  \
image of the guest machine system \033[0m"

VBoxManage modifyvm        vb_mdulcie --boot1 none
VBoxManage startvm         vb_mdulcie --type gui
