#!/bin/sh

. $(dirname $0)/lib.sh

docker run \
    --network ${DEPLOY_STACK_NAME}_internal_network \
    --rm -it ${DEPLOY_IMAGE_WEB:-myssh-web:latest} ${*:-sh}

