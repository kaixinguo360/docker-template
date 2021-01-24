#!/bin/bash

cd $(dirname $0)/..

set -o allexport
[ -f ./deploy.env ] && . ./deploy.env
set +o allexport

echo -n "Initing... " && {
    sudo ln -s -n /media/images ./var/library/local
} && echo 'done.'

