#!/bin/bash

# Переходим в созданную папку
cd ~/myfolder

# Подсчитываем количество файлов
file_count=$(ls | wc -l)
echo "В папке myfolder создано $file_count файлов"

# Меняем права доступа для второго файла
chmod 664 file2.txt

# Находим и удаляем пустые файлы
find . -type f -empty -delete

# Оставляем только первую строку в оставшихся файлах
for file in *; do
    if [[ -f "$file" ]]; then
        sed -i '2,$d' "$file"
    fi
done
