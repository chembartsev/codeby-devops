
#!/bin/bash

# Обновление системы
sudo apt-get update -y
sudo apt-get upgrade -y

# Установка Apache и SSL
sudo apt-get install -y apache2
sudo apt-get install -y ssl-cert

# Настройка Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Установка дополнительных инструментов
sudo apt-get install -y curl
sudo apt-get install -y openssh-server

# Настройка SSH
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Создание тестовой страницы
echo "<h1>Server is working!</h1>" | sudo tee /var/www/html/index.html