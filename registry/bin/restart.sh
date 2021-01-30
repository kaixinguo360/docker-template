#!/bin/sh

. $(dirname $0)/lib.sh

./bin/stop.sh
sleep 1
./bin/start.sh

