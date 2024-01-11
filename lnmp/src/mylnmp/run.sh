#!/bin/sh

replace() {
    local target source
    source="$(realpath "$1")"
    target="$2"
    printf 'Replace %s -> %s\n' "$target" "$source"
    rm -rf "$target"
    ln -s "$source" "$target"
}

cd /var/www

# Config #

[ -f './init.sh' ] \
    && printf 'Init script: %s' "$(realpath ./init.sh)" \
    && . ./init.sh

if [ -n "$DEBUG" ]; then
    printf 'DEBUG=true\n'
    mv "$PHP_INI_DIR/php-dev.ini" "$PHP_INI_DIR/php.ini"
else
    printf 'DEBUG=false\n'
    mv "$PHP_INI_DIR/php-prod.ini" "$PHP_INI_DIR/php.ini"
fi

[ -f './nginx.conf' ] \
    && replace ./nginx.conf /etc/nginx/http.d/default.conf
[ -d './nginx.conf.d' ] \
    && replace ./nginx.conf.d /etc/nginx/http.d
[ -d './nginx.ext' ] \
    && replace ./nginx.ext /etc/nginx/conf.ext
[ -d './nginx' ] \
    && replace ./nginx /etc/nginx

[ -f './php.ini' ] \
    && replace ./php.ini "$PHP_INI_DIR/conf.d/default.ini"
[ -d './php.conf.d' ] \
    && replace ./php.conf.d "$PHP_INI_DIR/conf.d"
[ -d './php' ] \
    && replace ./php "$PHP_INI_DIR"

# Run #

if [ -n "$NGINX_ONLY" -a "$NGINX_ONLY" != 'false' ]; then
    printf 'NGINX_ONLY=true\n'
else
    printf 'NGINX_ONLY=false\n'
    php-fpm &
fi

if [ -n "$DB_HOST" ]; then

    printf 'DB_HOST=%s\nDB_PORT=%s\nDB_LOCAL_PORT=%s\n' \
        "$DB_HOST" "$DB_PORT" "$DB_LOCAL_PORT"

    printf 'Socat %s -> %s\n' "/run/mysqld/mysqld.sock" "$DB_HOST:$DB_PORT"
    mkdir -p /run/mysqld/
    socat UNIX-LISTEN:/run/mysqld/mysqld.sock,fork,mode=777 TCP:$DB_HOST:$DB_PORT &

    if [ -n "$DB_LOCAL_PORT" ]; then
        printf 'Socat %s -> %s\n' "127.0.0.1:$DB_LOCAL_PORT" "$DB_HOST:$DB_PORT"
        socat TCP-LISTEN:$DB_LOCAL_PORT,fork TCP:$DB_HOST:$DB_PORT &
    fi
fi

nginx -g "daemon off;"

