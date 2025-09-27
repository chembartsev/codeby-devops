#!/bin/bash

# Обновление системы
apt-get update
apt-get upgrade -y

# Установка rsync
apt-get install -y rsync

# Создание директории для бэкапов
mkdir -p /opt/store/mysql
chown vagrant:vagrant /opt/store/mysql

# Настройка SSH для упрощения подключения
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
echo -e "vagrant\nvagrant" | sudo passwd vagrant 2>/dev/null
systemctl restart ssh

# Создание тестового файла для проверки
echo "Backup store ready: $(date)" > /opt/store/mysql/README.txt

echo "Настройка store завершена!"