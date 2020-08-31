#!/bin/bash

cd $(dirname $0)

docker network create \
    -d overlay \
    --attachable \
    external_network
