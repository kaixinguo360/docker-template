#!/bin/sh

. $(dirname $0)/lib.sh

docker stack ps $DEPLOY_STACK_NAME "$@"

