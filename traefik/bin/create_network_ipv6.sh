#!/bin/bash

cd $(dirname $0)

docker network create \
    --scope=swarm \
    --ipv6 \
    --attachable \
    ipv6_network
