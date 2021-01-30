#!/bin/sh

. $(dirname $0)/lib.sh

docker stack rm $DEPLOY_STACK_NAME

