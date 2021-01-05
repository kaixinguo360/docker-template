#!/bin/bash

cd $(dirname $0)/..

set -o allexport
[ -f ./node.env ] && . ./node.env
set +o allexport

set -o allexport
[ -f ./node.env ] && . ./node.env
set +o allexport

docker stack deploy -c docker-compose.yml jellyfin
