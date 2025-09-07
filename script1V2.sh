#!/bin/bash

#************************************************#
# script1V2.sh                                   #
# автор: chembartsev                             #
# сентябрь 2025                                  #
#                                                #
# скрипт1 для задания 10 урок 11                 #
#************************************************#

# Константы 

FILE1="file1.txt"
FILE2="file2.txt"
FILE3="file3.txt"
FILE4="file4.txt"
FILE5="file5.txt"


# Создаем папку myfolder в домашней директории
mkdir ~/myfolder
cd ~/myfolder || exit

# Создаем первый файл с приветствием и датой
echo "Привет, тест урок 11!" > "$FILE1"
date >> "$FILE1"

# Создаем второй файл с правами 777
touch "$FILE2"
chmod 777 "$FILE2"

# Создаем третий файл со случайной строкой
tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 20 > "$FILE3"

# Создаем два пустых файла
touch "$FILE4"
touch "$FILE5"
