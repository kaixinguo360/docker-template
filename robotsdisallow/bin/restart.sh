#!/bin/sh

. $(dirname $0)/lib.sh

./bin/stop.sh $PROFILE
sleep 1
./bin/start.sh $PROFILE

