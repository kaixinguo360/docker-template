#!/bin/sh

. $(dirname $0)/lib.sh

if [ -n "$DEPLOY_LOCAL_MOUNT_POINT" ]; then
  id=$(
    docker create \
      -v "${DEPLOY_LOCAL_MOUNT_POINT}":/root \
      --rm -it ${DEPLOY_IMAGE_DB_RUN:-mariadb:10.5} ${*:-bash}
  )
else
  id=$(
    docker create \
      --rm -it ${DEPLOY_IMAGE_DB_RUN:-mariadb:10.5} ${*:-bash}
  )
fi

docker network connect external_network $id
docker network connect ${DEPLOY_NETWORK_DB:-db_network} $id

docker start $id
docker attach $id
