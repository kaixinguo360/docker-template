#!/bin/sh

printf 'Update ip infos\n'

[ -z "$IPSTACK_ACCESS_KEY" ] \
    && echo "[ERROR] IPSTACK_ACCESS_KEY not set" >&2 \
    && exit 1

cd $(dirname $0)

SQL="CREATE TABLE IF NOT EXISTS ips ( \
    ip CHAR(15) NOT NULL PRIMARY KEY, \
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, \
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, \
    continent_code CHAR(4), \
    continent_name VARCHAR(64), \
    country_code CHAR(4), \
    country_name VARCHAR(64), \
    region_code CHAR(4), \
    region_name VARCHAR(64), \
    city VARCHAR(64), \
    zip VARCHAR(16), \
    latitude DOUBLE, \
    longitude DOUBLE , \
    geoname_id VARCHAR(16)\
    )ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;"

echo "$SQL" | mysql-cli.sh
echo 'SELECT DISTINCT rhost FROM passwords WHERE rhost NOT IN (SELECT DISTINCT ip FROM ips) AND rhost!="" GROUP BY rhost' \
    | mysql-cli.sh \
    | awk '{system("./iplookup.sh "$0" ips | mysql-cli.sh")}'
