# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Общие настройки
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_check_update = false
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end

  # testingserver
  config.vm.define "testingserver" do |server|
    server.vm.hostname = "testingserver"
    server.vm.network "public_network", ip: "192.168.56.107"
    
    # Скрипт для настройки SSH
    server.vm.provision "shell", inline: <<-SHELL
      sudo apt update
      sudo apt install openssh-server -y
      sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
      sudo sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config
      sudo sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
      sudo systemctl restart ssh
    SHELL
  end

  # testingclient
  config.vm.define "testingclient" do |client|
    client.vm.hostname = "testingclient"
    client.vm.network "public_network", ip: "192.168.56.108"
    
    
    client.vm.provision "shell", inline: <<-SHELL
      sudo apt update
      sudo apt install -y sshpass

          sleep 10

           mkdir -p /home/vagrant/.ssh
      chmod 700 /home/vagrant/.ssh
      ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N "" -q

      sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 vagrant@192.168.56.107 "mkdir -p ~/.ssh && echo '$(cat /home/vagrant/.ssh/id_rsa.pub)' >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

      
      ssh -o StrictHostKeyChecking=no vagrant@192.168.56.107 
    SHELL
  end
end



