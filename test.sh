#!/bin/bash

# Tạo file CSV với header
echo "name,img,category,status,tag1,tag2,tag3,tag4,tag5,tag6,tag7,tag8,tag9,tag10" > output.csv

# Đọc từng URL từ data.txt
while IFS= read -r url; do
    # Tải HTML từ URL, sử dụng -L để theo redirect nếu cần
    html=$(curl -s -L "$url")

    # Trích xuất name từ <h1 class="tieu-de-truyen">
    name=$(echo "$html" | grep -oP '<h1 class="tieu-de-truyen">\K[^<]+(?=</h1>)' | sed 's/"/""/g' | tr -d '\n')

    # Trích xuất img từ data-src trong <div class="thumb-bg">
    img=$(echo "$html" | grep -oP '<div class="thumb-bg">.*?<img[^>]*data-src="\K[^"]+(?=")' | head -n1 | sed 's/"/""/g')

    # Trích xuất category từ alt của các img trong <div class="info-genre">
    categories=$(echo "$html" | grep -oP '<div class="info-genre">.*?</div>' | grep -oP 'alt="\K[^"]+(?=")' | paste -sd ',' - | sed 's/"/""/g')

    # Trích xuất status từ văn bản trong các <div> con trực tiếp của <div class="info-status">
    status=$(echo "$html" | grep -oP '<div class="info-status">.*?</div>' | grep -oP '<div>\K[^<]+(?=</div>)' | paste -sd ',' - | sed 's/"/""/g')

    # Trích xuất tags từ văn bản trong <a class="tag-item">
    tags=($(echo "$html" | grep -oP '<a class="tag-item"[^>]*>\K#[^<]+(?=</a>)' | head -n10))

    # Điền tags vào các biến tag1 đến tag10, nếu không đủ thì để trống
    tag1="${tags[0]:-}"; tag1=$(echo "$tag1" | sed 's/"/""/g')
    tag2="${tags[1]:-}"; tag2=$(echo "$tag2" | sed 's/"/""/g')
    tag3="${tags[2]:-}"; tag3=$(echo "$tag3" | sed 's/"/""/g')
    tag4="${tags[3]:-}"; tag4=$(echo "$tag4" | sed 's/"/""/g')
    tag5="${tags[4]:-}"; tag5=$(echo "$tag5" | sed 's/"/""/g')
    tag6="${tags[5]:-}"; tag6=$(echo "$tag6" | sed 's/"/""/g')
    tag7="${tags[6]:-}"; tag7=$(echo "$tag7" | sed 's/"/""/g')
    tag8="${tags[7]:-}"; tag8=$(echo "$tag8" | sed 's/"/""/g')
    tag9="${tags[8]:-}"; tag9=$(echo "$tag9" | sed 's/"/""/g')
    tag10="${tags[9]:-}"; tag10=$(echo "$tag10" | sed 's/"/""/g')

    # Append dòng vào CSV, bao quanh bằng dấu ngoặc kép
    echo "\"$name\",\"$img\",\"$categories\",\"$status\",\"$tag1\",\"$tag2\",\"$tag3\",\"$tag4\",\"$tag5\",\"$tag6\",\"$tag7\",\"$tag8\",\"$tag9\",\"$tag10\"" >> output.csv

    # Thông báo hoàn thành thu thập thông tin từ URL
    echo "Đã thu thập xong thông tin từ: $url"

done < data.txt
