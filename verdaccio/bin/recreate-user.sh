#!/bin/sh

. $(dirname $0)/lib.sh

if [ -z `docker image ls httpd:alpine -q` ]; then
    printf 'Pulling tool image httpd:alpine... '
    docker pull httpd:alpine >/dev/null \
        && printf 'ok\n' \
        || exit 1
fi

docker volume rm -f tmp_volume >/dev/null || exit 1
docker volume create tmp_volume \
    --driver local \
    -o "type=nfs" \
    -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
    -o "device=:$DEPLOY_DATA_ROOT/$DEPLOY_STACK_NAME" \
    >/dev/null \
    || exit 1

docker run -it --rm -v tmp_volume:/data httpd:alpine \
    sh -c " \
        read -p 'User Name: ' USER_NAME;
        htpasswd -c /data/config/htpasswd \"\$USER_NAME\"; \
        chown -R 10001:65533 /data; \
    " \
    || exit 1

docker volume rm -f tmp_volume >/dev/null \
    || exit 1

