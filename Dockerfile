FROM debian:11
# unzip 在安装PHP扩展时需要

RUN apt update && apt-get install redis-server supervisor sudo git wget unzip cron curl -y
# 添加PHP源
RUN apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 -y
# 导入GPG密钥
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
# 安装PHP7.4
RUN DEBIAN_FRONTEND=noninteractive apt install php7.4 php7.4-fpm -y
RUN mkdir /run/php
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
# PHP 扩展
RUN apt install php7.4-redis php7.4-fileinfo php7.4-mysql php7.4-curl php7.4-xml -y
# 定时任务
RUN (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/php /v2b/artisan schedule:run >> /dev/null 2>&1") | crontab -
# 进程守护
RUN echo "[supervisord]" > /etc/supervisor/conf.d/supervisord.conf \
&& echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "[program:redis]" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "command=redis-server" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "[program:phpfpm]" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "command=php-fpm7.4 -F" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "[program:cron]" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "command=cron -f" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "[program:horizon]" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "command=php /v2b/artisan horizon" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autostart=true" >> /etc/supervisor/conf.d/supervisord.conf \
&& echo "autorestart=true" >> /etc/supervisor/conf.d/supervisord.conf 

RUN apt clean all
EXPOSE 9000
ENTRYPOINT ["supervisord"]

