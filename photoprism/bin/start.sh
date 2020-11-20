#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_WEB="node.hostname==m.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml photoprism
