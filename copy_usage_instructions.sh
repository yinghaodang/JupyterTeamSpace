#!/bin/bash

# 循环遍历所有用户的家目录，除了root用户
for user_home in /home/*; do
    # 获取用户名
    username=$(basename "$user_home")

    # 排除特殊用户
    if [ "$username" != "ying_hd" ]; then
        # 复制使用须知文件到用户家目录
        cp 使用须知.md "$user_home/使用须知.md"

        # 更改文件所有者为当前用户
        chown "$username:$username" "$user_home/使用须知.md"
    fi
done

