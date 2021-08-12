#!/bin/sh

. $(dirname $0)/lib.sh

docker run \
    -v "${DEPLOY_LOCAL_MOUNT_POINT?Please set local mount point for tmp docker container}":/root \
    --env-file ${DEPLOY_CONFIG_HDFS:-config/hdfs.env} \
    --env-file ${DEPLOY_CONFIG_YARN:-config/yarn.env} \
    --env-file ${DEPLOY_CONFIG_HBASE:-config/hbase.env} \
    --network ${DEPLOY_STACK_NAME}_internal_network \
    --rm -it ${DEPLOY_IMAGE_HBASE_RUN:-bde2020/hbase-master:1.0.0-hbase1.2.6} ${*:-bash}

