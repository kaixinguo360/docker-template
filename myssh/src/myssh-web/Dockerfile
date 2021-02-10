FROM php:7.2-fpm-alpine

RUN docker-php-ext-install mysqli

RUN apk add --no-cache nginx \
    && mkdir /run/nginx

COPY ./default.conf /etc/nginx/conf.d/

COPY ./www/ /var/www/

WORKDIR /var/www

CMD php-fpm & \
    nginx -g "daemon off;"

