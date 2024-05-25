#!/bin/bash
redis-server &
nginx
echo "Nginx started"
cron
echo "Cron started"
FLAG_FILE="/var/run/first_run.flag"
# 等待数据库启动
sleep 5
if [ ! -f "$FLAG_FILE" ]; then
    echo "Installing v2board..."
    cd /v2b && php artisan v2board:install
    touch "$FLAG_FILE"
    echo "Changing user group permissions, please wait..."
    echo "chmod -R 755 /v2b"
    chmod -R 755 /v2b
    echo "chown -R www-data:www-data /v2b"
    chown -R www-data:www-data /v2b
fi
supervisord &
# 最后启动 PHP-FPM
sleep 5
echo "Now you can visit your site."
php-fpm7.4 -F
