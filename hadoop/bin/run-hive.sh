#!/bin/sh

. $(dirname $0)/lib.sh

docker run \
    -v "${DEPLOY_LOCAL_MOUNT_POINT?Please set local mount point for tmp docker container}":/root \
    --env-file ${DEPLOY_CONFIG_HDFS:-config/hdfs.env} \
    --env-file ${DEPLOY_CONFIG_YARN:-config/yarn.env} \
    --env-file ${DEPLOY_CONFIG_HIVE:-config/hive.env} \
    --network ${DEPLOY_STACK_NAME}_internal_network \
    --rm -it ${DEPLOY_IMAGE_HIVE_RUN:-bde2020/hive:2.3.2-postgresql-metastore} ${*:-bash}

