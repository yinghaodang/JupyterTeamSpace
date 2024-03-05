#!/bin/bash

# 询问用户名
read -p "请输入用户名: " username

# 询问密码
read -sp "请输入密码: " password
echo

# 添加用户，并创建家目录
useradd -m -s /bin/bash $username

# 非交互式设置用户密码
echo "${username}:${password}" | chpasswd

# 为用户添加sudo权限，推荐使用/etc/sudoers.d/来避免直接修改/etc/sudoers文件
echo "$username ALL=(ALL) ALL" > /etc/sudoers.d/$username

# 确保sudoers.d目录下的文件权限正确
chmod 0440 /etc/sudoers.d/$username

# 询问是否自动激活base环境
read -p "是否自动激活base环境? (y/n): " activate_conda
if [ "$activate_conda" = "y" ]; then
    cat >> /home/${username}/.bashrc << "EOF"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
EOF
fi
