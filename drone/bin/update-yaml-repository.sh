#!/bin/sh

. $(dirname $0)/lib.sh

docker service update --force ${DEPLOY_STACK_NAME}_drone_yaml_repository

