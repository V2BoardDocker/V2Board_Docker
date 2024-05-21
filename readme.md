# V2Board in Docker

> [!IMPORTANT]
> 本镜像仅安装V2Board所需要的环境，你还需要手动下载V2Board并配置Web服务

## 安装步骤

### 1.构建镜像

- 下载 `Dockerfile`和 `entrypoint.sh`到同一目录
- 在当前目录执行 `docker build -t v2boart .`
- 等待构建完成

### 2.实例化镜像

- 为正常工作，你需要：
  * 克隆V2board仓库并挂载目录（Eg: `/openresty/www/sites/example.com/index`）到容器内`/v2b`
  * 暴露端口`9000`至主机
- 启动docker容器后执行 `docker exec -it <容器名称> /bin/sh -c "cd /v2b && sh init.sh"` 并按照提示配置数据库
- 重启容器

### 3.配置Web服务

- 请自行安装Nginx、Openresty等Web服务
- 运行目录 `/public/`
  * 示例：
  * ```nginx
    root /www/sites/v.9774.lol/index/public;
    ```
- 将fastcgi指向 `/v2b/public/index.php`
  * 示例：
  * ```nginx
    location ~ [^/]\.php(/|$) {
            fastcgi_pass 127.0.0.1:9000; 
            include fastcgi-php.conf; 
            include fastcgi_params; 
            fastcgi_param SCRIPT_FILENAME /v2b/public/index.php; 
        }
    ```

### 4.常见问题：

- HTTP 500 错误
  * 请手动执行 `chmod -R 755`这一点在V2board里也解答
  * 修改权限后依旧500？将文件夹用户和用户组递归修改为`www-data`
