#!/bin/bash

cd $(dirname $0)/..

set -o allexport
[ -f ./deploy.env ] && . ./deploy.env
set +o allexport

echo -n "Initing... " && {
    docker run --network rocket_internal_network --rm mongo:4.0 bash << 'HERE'
    for i in `seq 1 30`; do
      mongo db/rocketchat --eval \"
        rs.initiate({
          _id: 'rs0',
          members: [ { _id: 0, host: 'localhost:27017' } ]})\" &&
      s=$$? && break || s=$$?;
      echo \"Tried $$i times. Waiting 5 secs...\";
      sleep 5;
    done; (exit $$s)
HERE
} && echo 'done.'

