#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_WEB="node.hostname==c.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml jellyfin
