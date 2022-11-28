# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS_official_site_OS"
  config.vm.box_url = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 1
  end

  config.vm.define "mdulcieS" do |nodeS|
    nodeS.vm.hostname = "mdulcieS"
    nodeS.vm.network "private_network", ip: "192.168.56.110"
    nodeS.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--name", "mdulcieS"]
    end
    nodeS.vm.provision "shell",
      inline: "echo mdulcieS virtual machine created"
  end

  config.vm.define "mdulcieSW" do |nodeSW|
    nodeSW.vm.hostname = "mdulcieSW"
    nodeSW.vm.network "private_network", ip: "192.168.56.111"
    nodeSW.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--name", "mdulcieSW"]
    end
    nodeSW.vm.provision "shell",
      inline: "echo mdulcieSW virtual machine created"
  end
end


# Vagrant.configure("2") do |config|
#   config.vm.box = "mdulcieS"
#   config.vm.box_url = "file://work1/CentOS-8-Vagrant-8.4.2105-20210603.0.x86_64.vagrant-virtualbox.box"
#   config.vm.provision :shell, path: "bootstrap.sh"
#   config.vm.network :forwarded_port, guest: 80, host: 4567
# end