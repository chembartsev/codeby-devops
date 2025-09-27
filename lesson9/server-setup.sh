#!/bin/bash

# Обновление системы
apt-get update
apt-get upgrade -y

# Установка MySQL
apt-get install -y mysql-server

# Запуск MySQL
systemctl start mysql
systemctl enable mysql

# Настройка MySQL (упрощенная, без пароля)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
mysql -e "FLUSH PRIVILEGES;"

# Создание базы данных и таблиц
mysql -e "CREATE DATABASE IF NOT EXISTS company;"
mysql -e "USE company;

CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    position VARCHAR(100),
    salary DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    manager_id INT
);

INSERT IGNORE INTO employees (id, name, position, salary) VALUES 
(1, 'Иван Петров', 'Разработчик', 50000),
(2, 'Мария Сидорова', 'Менеджер', 60000),
(3, 'Алексей Иванов', 'Аналитик', 45000);

INSERT IGNORE INTO departments (id, name, manager_id) VALUES 
(1, 'IT', 1),
(2, 'Менеджмент', 2);"

# Создание директории для бэкапов
mkdir -p /opt/mysql_backup

# Копирование скрипта бэкапа
cat > /usr/local/bin/mysql_backup.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/opt/mysql_backup"
DATE=$(date +%Y%m%d_%H%M%S)
MYSQL_USER="root"

# Создание бэкапа
mysqldump -u$MYSQL_USER company > $BACKUP_DIR/company_$DATE.sql

# Удаление старых бэкапов (старше 7 дней)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete

echo "Бэкап создан: company_$DATE.sql"
EOF

chmod +x /usr/local/bin/mysql_backup.sh

# Копирование скрипта синхронизации
cat > /usr/local/bin/sync_backup.sh << 'EOF'
#!/bin/bash

STORE_IP="192.168.56.20"
BACKUP_DIR="/opt/mysql_backup"
STORE_DIR="/opt/store/mysql"
USER="vagrant"

# Генерация SSH ключа если нет
if [ ! -f /home/$USER/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f /home/$USER/.ssh/id_rsa -N "" -q
fi

# Копирование ключа на store (простой способ для теста)
ssh-keyscan -H $STORE_IP >> /home/$USER/.ssh/known_hosts

# Синхронизация
rsync -avz -e "ssh -o StrictHostKeyChecking=no" $BACKUP_DIR/ vagrant@$STORE_IP:$STORE_DIR/

echo "Синхронизация завершена: $(date)"
EOF

chmod +x /usr/local/bin/sync_backup.sh

# Настройка cron для бэкапа каждые 10 минут (для теста)
(crontab -l 2>/dev/null; echo "*/10 * * * * /usr/local/bin/mysql_backup.sh && /usr/local/bin/sync_backup.sh") | crontab -

# Разрешение SSH по паролю для упрощения (только для теста)
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart ssh

echo "Настройка server завершена!"