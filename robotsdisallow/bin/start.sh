#!/bin/sh

. $(dirname $0)/lib.sh

./bin/config.sh | {
    if [ -f "./docker-compose-$PROFILE.yml" ]; then
        docker stack deploy -c - -c "./docker-compose-$PROFILE.yml" $DEPLOY_STACK_NAME
    else
        docker stack deploy -c - $DEPLOY_STACK_NAME
    fi
}

