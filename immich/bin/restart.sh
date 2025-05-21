#!/bin/sh

. "$(dirname "$0")/lib.sh"

./bin/stop.sh "$PROFILE"
./bin/start.sh "$PROFILE"

