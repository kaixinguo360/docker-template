#!/bin/sh

. $(dirname $0)/lib.sh

printf "Initing... " && {
    sudo ln -s -n /media/images ./var/library/local
} && echo 'done.'

