#!/bin/bash

cd $(dirname $0)/..

set -o allexport
[ -f ./deploy.env ] && . ./deploy.env
set +o allexport

echo -n "Initing... " && {
    sudo chown -R 1000:1000 ./var/data
} && echo 'done.'

