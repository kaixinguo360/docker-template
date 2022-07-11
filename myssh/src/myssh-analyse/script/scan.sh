#!/bin/sh

mysql_cli () {
    mysql \
        -N \
        -h"${MYSQL_HOST}" \
        -u"${MYSQL_USER}" \
        -p"${MYSQL_PASSWORD}" \
        "${MYSQL_DATABASE}"
}

import_result()
{
    IP="$1"
    DATA_FILE="/tmp/nmap_${IP}.xml"
    DATA="$(cat "$DATA_FILE")"
    mysql_cli << HERE
INSERT INTO scans (ip, result)
VALUES ('$IP', '$DATA');
HERE
}

import_fail()
{
    IP="$1"
    mysql_cli << HERE
INSERT INTO scans (ip, result)
VALUES ('$IP', '');
HERE
}

mysql_cli << HERE
CREATE TABLE IF NOT EXISTS scans (
    ip CHAR(15) PRIMARY KEY,
    result TEXT,
    insert_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
HERE

echo "SELECT rhost FROM passwords \
    LEFT JOIN scans
    ON rhost = ip
    WHERE time > DATE_SUB(CURDATE(), INTERVAL 1 DAY)
    AND result is null
    GROUP BY rhost
    ORDER BY count(*) DESC
    LIMIT 50
    " \
    | mysql_cli \
    | while read ip
        do
            printf '[%s] scan ip %s ... ' "$(date)" "$ip"

            nmap \
                -oX "/tmp/nmap_$ip.xml" \
                --stylesheet https://nmap.org/data/nmap.xsl \
                --stats-every 5 \
                --script=auth,vuln \
                -A \
                "$ip" \
                >"/tmp/nmap_$ip.log" \
                2>&1

            if [ "$?" != '0' ]; then
                echo failed
                import_fail "$ip"
                continue
            else
                import_result "$ip"
                rm -f "/tmp/nmap_$ip.xml" "/tmp/nmap_$ip.log"
                echo 'done.'
            fi
        done

