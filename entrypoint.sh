#!/bin/bash

if [ ! -f /v2b/.env ]; then
    echo -e "\033[0;31m初次运行请使用 docker exec -it 容器名称 sh -c \"cd /v2b && sh init.sh\" 进行初始化\033[0m"
    echo -e "\033[0;31m初次运行请使用 docker exec -it 容器名称 sh -c \"cd /v2b && sh init.sh\" 进行初始化\033[0m"
    echo -e "\033[0;31m初次运行请使用 docker exec -it 容器名称 sh -c \"cd /v2b && sh init.sh\" 进行初始化\033[0m"
fi
sudo chmod -R 755 /v2b
sudo chown -R www-data:www-data /v2b
nginx
supervisord