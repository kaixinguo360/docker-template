#!/bin/sh

. $(dirname $0)/lib.sh

printf "Initing... " && {
    sudo chown -R 1000:1000 ./var/data
} && echo 'done.'

