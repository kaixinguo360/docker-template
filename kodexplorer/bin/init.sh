#!/bin/sh

. $(dirname $0)/lib.sh

printf "Initing... " \
  && docker volume rm -f tmp_volume >/dev/null || exit 1 \
  && docker volume create tmp_volume \
    --driver local \
    -o "type=nfs" \
    -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
    -o "device=:$DEPLOY_DATA_ROOT/${DEPLOY_STACK_NAME:-kodexplorer}" \
    >/dev/null || exit 1 \
  && docker run --rm -v tmp_volume:/data \
    alpine:3 sh -c 'rm -f /data/*/.gitkeep' \
    >/dev/null || exit 1 \
  && docker volume rm -f tmp_volume >/dev/null || exit 1 \
  && echo 'done.'

