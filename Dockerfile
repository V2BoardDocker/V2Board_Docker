FROM debian:11
# unzip 在安装PHP扩展时需要

RUN apt update && apt-get install redis-server nginx supervisor sudo git wget unzip cron curl -y
# 添加PHP源
RUN apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 -y
# 导入GPG密钥
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
# 安装PHP7.4
RUN DEBIAN_FRONTEND=noninteractive apt install php7.4 php7.4-fpm -y
RUN mkdir /run/php
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;*\s*error_log\s*=.*|error_log = /proc/self/fd/2|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;*\s*catch_workers_output\s*=.*|catch_workers_output = no|' /etc/php/7.4/fpm/pool.d/www.conf
# PHP 扩展
RUN apt install php7.4-redis php7.4-fileinfo php7.4-mysql php7.4-curl php7.4-xml -y
# 定时任务
RUN (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/php /v2b/artisan schedule:run ") | crontab -

# 进程守护
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/nginx.conf

RUN git clone https://github.com/wyx2685/v2board /v2b
COPY V2boardInstall.php /v2b/app/Console/Commands/V2boardInstall.php
RUN cd /v2b && rm -rf composer.phar && wget https://github.com/composer/composer/releases/latest/download/composer.phar -O composer.phar
RUN COMPOSER_ALLOW_SUPERUSER=1 cd /v2b && php composer.phar install -vvv

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN apt clean all

ENTRYPOINT ["sh","-c","/entrypoint.sh"]


