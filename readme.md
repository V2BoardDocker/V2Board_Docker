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

使用你自己的数据库？修改 `docker-compose.yaml` 内的环境变量，并注释掉 `db` 小节

默认Web端口 `8952`

**查看容器日志获取初始账户密码和管理入口**

## 更新面板

与官方一样，使用
```shell
docker exec -it v2board sh -c "cd /v2b && bash update.sh"
```

更新权限：
```shell
docker exec -it v2board sh -c "chmod -R 755 /v2b"
docker exec -it v2board sh -c "chown -R www-data:www-data /v2b"
```

## 卸载

删除容器即可

## 迁移
- 备份数据库
- 全新安装V2board
- 导入数据库
