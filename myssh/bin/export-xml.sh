#!/bin/sh

. $(dirname $0)/lib.sh

TARGET="${1:-./nmap_data}"
mkdir -p "$TARGET"

echo 'select result from scans' \
    | docker run \
        --network ${DEPLOY_STACK_NAME}_internal_network \
        --rm -i ${DEPLOY_IMAGE_WEB:-myssh-web:latest} \
        mysql-cli.sh \
    | sed 's/\\/\\\\/g' \
    | while read "line"
        do
            printf '%s\n' "$line" \
                | sed 's/\\n/\n/g' \
                | cat > "$TARGET/nmap_$(date +%N).xml"
        done
#    | sed -E \
#        -e 's/\\n//g' \
#        -e 's/^.*(<nmaprun.*\/nmaprun>).*$/\1/g'

