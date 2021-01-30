#!/bin/sh

. $(dirname $0)/lib.sh

cat << 'HERE'
# Use `info.sh > deploy.env` to save current config as default profile
# Use `info.sh > deploy-<profile>.env` to save current config as a new profile
# Use `start.sh <profile>` to deploy stack with saved profile
HERE

grep '${DEPLOY_[^}]*}\|$DEPLOY_[A-Z_a-z0-9]*' \
    -r -o -h \
    --exclude-dir=var \
    --exclude=info.sh \
    | sort -u \
    | xargs -l1 -i sh -c 'echo $(echo \{}|grep -o "DEPLOY_[A-Z_a-z0-9]*")=\"{}\"' \
    | sort -u

