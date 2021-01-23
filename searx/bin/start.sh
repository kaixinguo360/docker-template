#!/bin/bash

cd $(dirname $0)/..

set -o allexport
[ -f ./deploy.env ] && . ./deploy.env
set +o allexport

docker stack deploy -c docker-compose.yml searx
