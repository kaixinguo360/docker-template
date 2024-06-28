#!/bin/sh

. "$(dirname "$0")/lib.sh"

printf 'Preparing tmp volume... '
docker volume rm -f tmp_volume >/dev/null || exit 1
docker volume create tmp_volume \
    --driver local \
    -o "type=nfs" \
    -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
    -o "device=:$DEPLOY_DATA_ROOT/$DEPLOY_STACK_NAME/synapse" \
    >/dev/null \
    && printf 'ok\n' \
    || exit 1

printf 'Generating config file... \n'
{
    docker run --rm \
        -i \
        -v tmp_volume:/data \
        -e SYNAPSE_SERVER_NAME="${APP_SERVER_NAME}" \
        -e SYNAPSE_REPORT_STATS=no \
        ${DEPLOY_IMAGE_WEB:-matrixdotorg/synapse:v1.109.0rc2} \
        generate
} \
    && printf 'ok\n' \
    || exit 1

printf 'Removing tmp volume... '
docker volume rm -f tmp_volume >/dev/null \
    && printf 'ok\n' \
    || exit 1

