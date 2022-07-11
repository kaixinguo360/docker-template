#!/bin/sh

. $(dirname $0)/lib.sh

TARGET="/tmp/nmap"
mkdir -p "$TARGET"

echo 'exporting... '
echo 'SELECT result FROM scans
WHERE insert_time > DATE_SUB(CURDATE(), INTERVAL 1 DAY)
ORDER BY insert_time LIMIT 500' \
    | docker run \
        --network ${DEPLOY_STACK_NAME}_internal_network \
        --rm -i ${DEPLOY_IMAGE_WEB:-myssh-web:latest} \
        mysql-cli.sh \
    | sed 's/\\/\\\\/g' \
    | while read "line"
        do
            printf '.'
            printf '%s\n' "$line" \
                | sed 's/\\n/\n/g' \
                | cat > "$TARGET/nmap_$(date +%N).xml"
        done
echo ' ok'

echo 'importing... '
docker run --rm -i \
    -e DATABASE_URL="kaixinguo:19980404a.@w.kaixinguo.site:15432/test" \
    -v "$HOME"/dc/app-msf/data:/home/msf/.msf4 \
    -v "$HOME"/dc/app-msf/tmp:/tmp/data \
    -v "$TARGET":/tmp/nmap \
    metasploitframework/metasploit-framework \
    ./msfconsole \
        -q \
        -r docker/msfconsole.rc \
        -y /usr/src/metasploit-framework/config/database.yml \
        -x 'db_import /tmp/nmap/nmap_*.xml; exit'

rm -rf /tmp/nmap

