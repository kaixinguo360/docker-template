#!/bin/sh

. $(dirname $0)/lib.sh

id=$(
  docker create \
    -v "${DEPLOY_LOCAL_MOUNT_POINT?Please set local mount point for tmp docker container}":/root \
    --env-file ./config/hadoop.env \
    --rm -it ${DEPLOY_IMAGE_RUN_HDFS:-bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8} ${*:-bash}
)

docker network connect external_network $id
docker network connect ${DEPLOY_STACK_NAME}_internal_network $id

docker start $id
docker attach $id
