#!/bin/bash

DOMAIN="test.local"
SERVER_IP="192.168.56.10"

# Добавление в hosts
echo "$SERVER_IP $DOMAIN" >> /etc/hosts

# Ждем сервер
sleep 20

# Копируем сертификат и делаем доверенным
curl -k https://$SERVER_IP > /dev/null 2>&1
openssl s_client -connect $SERVER_IP:443 -showcerts </dev/null 2>/dev/null | \
openssl x509 -out /usr/local/share/ca-certificates/$DOMAIN.crt

update-ca-certificates

echo "Client ready. Test: curl https://$DOMAIN"

