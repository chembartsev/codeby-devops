#!/bin/bash

#************************************************#
# script2V2.sh                                   #
# автор: chembartsev                             #
# сентябрь 2025                                  #
#                                                #
# скрипт2 для задания 10 урок 11                 #
#************************************************#

ACCESS_PERMISSIONS=664
FILE2="file2.txt"

# Переходим в созданную папку
cd ~/myfolder || exit 1

# Подсчитываем количество файлов
file_count=$(find . -maxdepth 1 -type f | wc -l)
echo "В папке myfolder создано $file_count файлов"

# Меняем права доступа для второго файла
chmod "$ACCESS_PERMISSIONS" "$FILE2"

# Находим и удаляем пустые файлы
find . -type f -empty -delete

# Оставляем только первую строку в оставшихся файлах
for file in *; do
    if [[ -f "$file" ]]; then
        sed -i '2,$d' "$file"
    fi
done
