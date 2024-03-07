# 基本介绍

为小团队（3-10人）打造的简易化Jupyterhub环境，无需部署在Kubernetes中，支持运行在docker。
如果不使用显卡，可以用以前的版本0.1。


# 部署文档

``` bash
# 编译镜像
docker build -t reg.hdec.com/pdc/jupyterhub-for-team:4.0.2-cuda12.3.2-ubuntu22 .
```

```bash
# 启动容器
docker run -d -v ${user_data}:/home --restart always --shm-size 128g -p 8002:8000 --gpus all reg.hdec.com/pdc/jupyterhub-for-team
```

# docker-compose

也可以使用`docker-compose`方式部署。详见, `jupyterhub.yml`.


如果在`jupyterhub`里写Web服务，那么要多开一些端口。
至此，`jupyterhub`部署完成。访问`http://${host_ip}:8002`即可

## 创建用户

创建完用户之后，可以凭借账号密码登录`jupyterhub`

```bash
bash create_user_with_sudo.sh  # 创建用户
bash copy_usage_instructions.sh   # 将使用说明分发给用户
```

