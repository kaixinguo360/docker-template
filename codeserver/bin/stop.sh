#!/bin/sh

. "$(dirname "$0")/lib.sh"

docker stack rm "$DEPLOY_STACK_NAME"

until [ -z "$(docker stack ps "$DEPLOY_STACK_NAME" -q 2>/dev/null)" ]; do sleep 1; done

