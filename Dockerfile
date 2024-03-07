FROM nvcr.io/nvidia/cuda:12.3.2-devel-ubuntu22.04

WORKDIR /jupyterhub

# change to bash env
SHELL ["/bin/bash", "-c"]

ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH /usr/local/node-v20.11.1/bin:/usr/local/miniconda3/bin:$PATH
ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH

# base packages
RUN sed -i s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    rm /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list && \
    apt update && \
    apt install -y \
        iputils-ping net-tools telnet \
        wget curl unzip vim sudo \
        openssh-server openssh-client \
        git tzdata bash-completion \
        python3 && \
    apt autoremove

# npm pip config
ARG http_proxy http://10.215.59.186:7890
ARG https_proxy http://10.215.59.186:7890
RUN echo "registry=http://registry.npmmirror.com" > /root/.npmrc && \
    echo -e "[global]\nindex-url = https://mirror.baidu.com/pypi/simple" > /etc/pip.conf

# install nodejs and npm
RUN wget "https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-x64.tar.xz" && \
    tar -xvf node-v20.11.1-linux-x64.tar.xz && \
    mv node-v20.11.1-linux-x64 /usr/local/node-v20.11.1 && \
    rm node-v20.11.1-linux-x64.tar.xz

# install jupyterhub with /usr/bin/python3
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3 - && \
    npm install -g configurable-http-proxy && \
    python3 -m pip install --upgrade jupyterhub && \
    python3 -m pip install --upgrade jupyterlab

# install miniconda3 for team members
RUN wget -O miniconda3.sh "https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py310_23.11.0-1-Linux-x86_64.sh" && \
    chmod +x miniconda3.sh && \
    bash miniconda3.sh  -b -p /usr/local/miniconda3 && \
    rm miniconda3.sh

# conda config
RUN echo -e "channels:\n  - defaults\nshow_channel_urls: true\ndefault_channels:\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2\ncustom_channels:\n  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/" > /usr/local/miniconda3/.condarc

# vim config
RUN echo "set encoding=utf-8 fileencodings=utf-8" >> /etc/vim/vimrc

VOLUME ["/home", "/jupyterhub"]

EXPOSE 8000

CMD ["jupyterhub"]
