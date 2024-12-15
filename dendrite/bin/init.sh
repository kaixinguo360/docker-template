#!/bin/sh

. "$(dirname "$0")/lib.sh"

printf 'Preparing tmp volume... '
docker volume rm -f tmp_volume >/dev/null || exit 1
docker volume create tmp_volume \
    --driver local \
    -o "type=nfs" \
    -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
    -o "device=:$DEPLOY_DATA_ROOT/$DEPLOY_STACK_NAME/data" \
    >/dev/null \
    && printf 'ok\n' \
    || exit 1

printf 'Generating private key... \n'
{
    docker run --rm \
        -i \
        -v tmp_volume:/var/dendrite \
        --entrypoint="/usr/bin/generate-keys" \
        ${DEPLOY_IMAGE_WEB:-matrixdotorg/dendrite-monolith:v0.13.7} \
        -private-key /var/dendrite/matrix_key.pem
} \
    && printf 'ok\n' \
    || exit 1

printf 'Removing tmp volume... '
docker volume rm -f tmp_volume >/dev/null \
    && printf 'ok\n' \
    || exit 1

