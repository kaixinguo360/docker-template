#!/bin/sh

. $(dirname $0)/lib.sh

printf 'Starting stack %s...\n' "$DEPLOY_STACK_NAME"
./bin/start.sh $PROFILE 2>&1 | sed 's/^/  /g'
printf 'ok\n'

printf 'Initing db...\n'
docker run \
    --network ${DEPLOY_STACK_NAME}_internal_network \
    --rm -i mongo:4.0 bash -c "
      for i in \`seq 1 30\`; do
        mongo db/rocketchat --eval \"
          rs.initiate({
            _id: 'rs0',
            members: [ { _id: 0, host: 'localhost:27017' } ]})\" &&
        s=\$? && break || s=\$?;
        echo \"Tried \$i times. Waiting 5 secs...\";
        sleep 5;
      done; (exit \$s)" 2>&1 | sed 's/^/  /g'
printf 'ok\n'

printf 'Stopping stack %s...\n' "$DEPLOY_STACK_NAME"
./bin/stop.sh $PROFILE 2>&1 | sed 's/^/  /g'
printf 'ok\n'

