#!/bin/sh

. $(dirname $0)/lib.sh

./bin/config.sh | docker stack deploy -c - $DEPLOY_STACK_NAME

