#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_WEB="node.hostname != notuse" \
DEPLOY_NODE_DB="node.hostname != notuse" \

DEPLOY_NODE_WEB="node.hostname==t.<secret:HOST_NAME>" \
DEPLOY_NODE_DB="node.hostname==t.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml mylist
