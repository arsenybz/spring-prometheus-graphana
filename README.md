1) Установить VagrantVM

sudo apt update
sudo apt install virtualbox -y

sudo usermod -aG vboxusers $USER

npm config delete prefix

newgrp vboxusers


sudo apt update
sudo apt install vagrant -y

vagrant --version

mkdir vaagrant-postgres && cd vaagrant-postgres

vagrant init bento/ubuntu-20.04

vagrant up


Для штатного выключения использовать: vagrant halt

Для заморозки состояния, чтобы можно было перезагрузить основной компьютер: vagrant suspend



```bash
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
ENV['VAGRANT_SERVER_URL'] = 'https://vagrant.elab.pro'

Vagrant.configure("2") do |config|
# The most common configuration options are documented and commented below.
# For a complete reference, please see the online documentation at
# https://docs.vagrantup.com.

# Every Vagrant development environment requires a box. You can search for
# boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/jammy64"

  config.disksize.size = "50GB"

  config.vm.provider "virtualbox" do |v|
     # Don't boot with headless mode
     v.memory = 4096
     v.cpus = 2
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.network "private_network", ip: "192.168.50.1", virtualbox__intnet: "net1"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.provision "shell", inline: <<-SHELL
      mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh;
      echo ssh-rsa 1234567
    SHELL
  end

end
```

