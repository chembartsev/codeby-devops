#!/bin/bash

# Создаем папку myfolder в домашней директории
mkdir ~/myfolder
cd ~/myfolder

# Создаем первый файл с приветствием и датой
echo "Привет, тест!" > file1.txt
date >> file1.txt

# Создаем второй файл с правами 777
touch file2.txt
chmod 777 file2.txt

# Создаем третий файл со случайной строкой
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 20 > file3.txt

# Создаем два пустых файла
touch file4.txt
touch file5.txt
