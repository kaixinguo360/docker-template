#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_WEB="node.hostname==p.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml photoview