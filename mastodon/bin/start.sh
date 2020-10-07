#!/bin/bash

cd $(dirname $0)/..

DEPLOY_NODE_WEB="node.hostname==w.<secret:HOST_NAME>" \
DEPLOY_NODE_REDIS="node.hostname==w.<secret:HOST_NAME>" \
DEPLOY_NODE_DB="node.hostname==m.<secret:HOST_NAME>" \
DEPLOY_NODE_STREAMING="node.hostname==m.<secret:HOST_NAME>" \
DEPLOY_NODE_SIDEKIQ="node.hostname==m.<secret:HOST_NAME>" \
docker stack deploy -c docker-compose.yml mastodon
