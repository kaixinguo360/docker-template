#!/bin/sh

mysql \
    -N \
    -h"${MYSQL_HOST}" \
    -u"${MYSQL_USER}" \
    -p"${MYSQL_PASSWORD}" \
    "${MYSQL_DATABASE}"
