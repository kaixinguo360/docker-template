#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_GRAFANA="node.hostname==p.<secret:HOST_NAME>" \
DEPLOY_NODE_LOKI="node.hostname==p.<secret:HOST_NAME>" \
DEPLOY_NODE_INFLUXDB="node.hostname==m.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml plg
