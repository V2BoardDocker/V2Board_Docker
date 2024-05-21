# V2Board in Docker

> [!IMPORTANT]
> 本仓库并非V2board官方Docker仓库

## 使用方法：

创建容器

```shell
git clone https://github.com/V2BoardDocker/V2Board_Docker
cd V2Board_Docker
docker-compose up -d
```

容器启动后需对v2board进行初始化

```shell
docker exec -it v2board sh -c "cd /v2b && sh init.sh"
```

默认容器名称 `v2board`

默认Web端口 `8952`

## 更新面板

与官方一样，使用
```shell
docker exec -it v2board sh -c "cd /v2b && sh update.sh"
```

## 卸载

删除容器即可
