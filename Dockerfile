FROM quay.io/jupyterhub/jupyterhub

WORKDIR /root/

# change to bash env
SHELL ["/bin/bash", "-c"]

# base packages
RUN sed -i s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    apt update && \
    apt install -y \
        iputils-ping net-tools telnet \
        wget unzip vim sudo \
        openssh-server openssh-client \
        git tzdata bash-completion

# pip, conda config
RUN echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" > /etc/pip.conf

ENV TZ=Asia/Shanghai

RUN pip install jupyter_core==5.7.1 jupyter_server==2.12.5 jupyterlab==4.1.2

RUN wget -O miniconda3.sh "https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py310_23.11.0-1-Linux-x86_64.sh" && \
    chmod +x miniconda3.sh && \
    bash miniconda3.sh  -b -p /usr/local/miniconda3 && \
    rm miniconda3.sh

ENV PATH /usr/local/miniconda3/bin:$PATH

RUN echo -e "channels:\n  - defaults\nshow_channel_urls: true\ndefault_channels:\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r\n  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2\ncustom_channels:\n  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud\n  deepmodeling: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/" > /usr/local/miniconda3/.condarc

VOLUME ["/home"]

EXPOSE 22 30000 30001 30002

CMD ["jupyterhub", "--ip", "0.0.0.0"]
