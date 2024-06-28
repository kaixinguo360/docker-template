#!/bin/sh

. "$(dirname "$0")/lib.sh"

./bin/config.sh "$PROFILE" | {
    if [ -z "$PROFILE" -a -f "./deploy-compose.yml" ]; then
        docker stack deploy -c - -c "./deploy-compose.yml" "$DEPLOY_STACK_NAME"
    elif [ -n "$PROFILE" -a -f "./deploy-compose-$PROFILE.yml" ]; then
        docker stack deploy -c - -c "./deploy-compose-$PROFILE.yml" "$DEPLOY_STACK_NAME"
    else
        docker stack deploy -c - "$DEPLOY_STACK_NAME"
    fi
}

