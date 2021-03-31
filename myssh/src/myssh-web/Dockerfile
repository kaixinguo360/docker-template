FROM php:7.2-fpm-alpine

RUN docker-php-ext-install mysqli

ENV PATH="/usr/local/openssh/script:/usr/local/openssh/bin:/usr/local/openssh/sbin:$PATH"
ENV MYSQL_HOST=db
ENV MYSQL_USER=myssh
ENV MYSQL_PASSWORD=1234567
ENV MYSQL_DATABASE=myssh

RUN apk add --no-cache nginx mysql-client jq curl \
    && mkdir /run/nginx \
    && echo "*/30 * * * * /usr/local/openssh/script/update-ips.sh" >> /var/spool/cron/crontabs/root

COPY ./default.conf /etc/nginx/conf.d/
COPY ./www/ /var/www/
COPY script/ /usr/local/openssh/script

WORKDIR /var/www

CMD crond -f & \
    php-fpm & \
    nginx -g "daemon off;"

