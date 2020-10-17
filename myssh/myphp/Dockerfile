FROM php:7.2-fpm-alpine

RUN docker-php-ext-install mysqli

WORKDIR /var/www

RUN apk add --no-cache nginx \
    && mkdir /run/nginx

COPY default.conf /etc/nginx/conf.d/

CMD php-fpm & \
    nginx -g "daemon off;"

