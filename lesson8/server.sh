#!/bin/bash

DOMAIN="test.local"
WWW_DOMAIN="www.test.local"

# Установка Apache
apt update && apt install -y apache2 openssl

# Создание SSL сертификата
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache.key \
  -out /etc/ssl/certs/apache.crt \
  -subj "/C=RU/CN=$DOMAIN"

# Конфигурация Apache
cat > /etc/apache2/sites-available/default-ssl.conf << EOF
<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias $WWW_DOMAIN
    DocumentRoot /var/www/html
    
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache.crt
    SSLCertificateKeyFile /etc/ssl/private/apache.key

    # Redirect www to non-www
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\. [NC]
    RewriteRule ^(.*)$ https://$DOMAIN\$1 [R=301,L]
</VirtualHost>

<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias $WWW_DOMAIN
    Redirect permanent / https://$DOMAIN/
</VirtualHost>
EOF

# Включение модулей
a2enmod ssl rewrite
a2ensite default-ssl.conf
a2dissite 000-default.conf

systemctl restart apache2

echo "Server setup completed!"