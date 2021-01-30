#!/bin/sh

. $(dirname $0)/lib.sh

printf "Initing... " && {
    docker-compose run web init
} && echo 'done.'

