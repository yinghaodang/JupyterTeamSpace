# 部署文档

``` bash
# 编译镜像
docker build -t reg.hdec.com/pdc/jupyterhub-for-team .
```

```bash
# 启动容器
docker run -d -v /home/jupyterhub:/home --restart always --shm-size 128g -p 8002:8000 -p 8003:22 -p 30000:30000 -p 30001:30001  -p 30002:30002 --gpus all reg.hdec.com/pdc/jupyterhub-for-team
```

至此，`jupyterhub`部署完成。

## 创建用户

创建完用户之后，可以凭借账号密码登录`jupyterhub`

```bash
bash create_user_with_sudo.sh  # 手动docker cp 到容器里
```

