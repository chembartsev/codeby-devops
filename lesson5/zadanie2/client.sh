#!/bin/bash

# Обновление системы
sudo apt-get update -y
sudo apt-get upgrade -y

# Установка SSH
sudo apt-get install -y openssh-server

# Настройка SSH
sudo sed -i 's/#AllowUsers/AllowUsers vagrant@server/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Установка дополнительных инструментов
sudo apt-get install -y curl

# Настройка брандмауэра
sudo ufw allow ssh
sudo ufw enable

