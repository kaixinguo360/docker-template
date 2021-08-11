#!/bin/sh

. $(dirname $0)/lib.sh

docker run \
    -v "${DEPLOY_LOCAL_MOUNT_POINT?Please set local mount point for tmp docker container}":/root \
    --env-file ${DEPLOY_CONFIG_HADOOP:-config/hadoop.env} \
    --network ${DEPLOY_STACK_NAME}_internal_network \
    --rm -it ${DEPLOY_IMAGE_RUN_HIVE:-bde2020/hive:2.3.2-postgresql-metastore} ${*:-bash}

