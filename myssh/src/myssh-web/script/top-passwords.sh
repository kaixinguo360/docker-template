#!/bin/sh

[ -z "$1" ] && set 100

case "$1" in
    -h|--help)
        printf 'Usage: %s [limit]\nPrint the top 100(or $limit) most frequent passwords appeared in 24 hours\n' `basename $0`
        exit 0;;
    -*)
        printf 'unrecognized option: %s\n' "$1" >&2
        exit 1;;
esac

cd $(dirname $0)

echo "SELECT password FROM passwords \
    WHERE time > DATE_SUB(CURDATE(), INTERVAL 1 DAY)
    GROUP BY password
    ORDER BY count(*) DESC
    LIMIT $1
    " | mysql-cli.sh
