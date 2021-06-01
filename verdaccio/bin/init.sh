#!/bin/sh

. $(dirname $0)/lib.sh

printf 'Preparing tmp volume... '
docker volume rm -f tmp_volume >/dev/null || exit 1
docker volume create tmp_volume \
    --driver local \
    -o "type=nfs" \
    -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
    -o "device=:$DEPLOY_DATA_ROOT/$DEPLOY_STACK_NAME" \
    >/dev/null \
    && printf 'ok\n' \
    || exit 1

printf 'Changing owner of data dir.. '
docker run --rm -v tmp_volume:/data alpine:3 \
    sh -c "chown -R 10001:65533 /data" \
    && printf 'ok\n' \
    || exit 1

printf 'Removing tmp volume... '
docker volume rm -f tmp_volume >/dev/null \
    && printf 'ok\n' \
    || exit 1

