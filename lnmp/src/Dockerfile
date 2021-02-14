FROM php:7.2-fpm-alpine

# Plugin
RUN docker-php-ext-install \
        mysqli \
        pdo_mysql
RUN apk add --no-cache \
        libpng-dev \
    && docker-php-ext-install \
        gd

# PHP
COPY php-dev.ini php-prod.ini "$PHP_INI_DIR/"

# Nginx
RUN apk add --no-cache \
        nginx \
        socat \
    && mkdir /run/nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD mkdir /etc/nginx/conf.ext
EXPOSE 80
WORKDIR /var/www

# Time Zone
RUN apk add --no-cache tzdata \
    && cp -f \
        /usr/share/zoneinfo/Asia/Shanghai \
        /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del --no-cache tzdata

# Change UID & GID of www-data
RUN apk add --no-cache shadow \
    && usermod -u 1000 www-data \
    && groupmod -g 1000 www-data \
    && find / -user 82 -exec chown -h www-data {} \; \
    && find / -group 82 -exec chgrp -h www-data {} \; \
    && apk del --no-cache shadow

# Run Script
ENV DB_HOST='' \
    DB_PORT='' \
    DB_LOCAL_PORT='' \
    DEBUG=''
COPY run.sh /opt/run.sh
RUN chmod +x /opt/run.sh
CMD /opt/run.sh

