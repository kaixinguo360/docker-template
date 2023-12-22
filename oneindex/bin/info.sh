#!/bin/sh

. "$(dirname "$0")/lib.sh"

cat << HERE
# Use \`info.sh > deploy.env\` to save current config as default profile
# Use \`info.sh > deploy-<profile>.env\` to save current config as a new profile
# Use \`deploy.sh <profile>\` to deploy a new stack with specific profile
# Use \`start.sh <profile>\` and \`stop.sh <profile>\` to start/stop deployed stack
# All <profile> arguments can be omitted or replaced with \`-\` to use default profile
#
# The followings are all optional features, which can be enabled by adding to the DEPLOY_ENABLED_FEATURE
# environment variable. Separate multiple enabled features with \`|\`
# Use \`grep -n '#.<feature-name>' ./docker-compose.yml\` to see the meaning of each feature
$(sed -nE 's/.*#[!:]([^ |]*).*/# - \1/p' docker-compose.yml | sort -u)
#
HERE

grep '${DEPLOY_[^\[}]\+}\|$DEPLOY_[A-Z_a-z0-9]\+' \
    -r -o -h \
    ./bin/* ./config/* ./docker-compose*.yml \
    2>/dev/null \
    | sort -u \
    | xargs -n1 -I{} sh -c 'echo $(echo \{}|grep -o "DEPLOY_[A-Z_a-z0-9]\+")=\"{}\"' 2>&1 \
    | sort -u \
    | sed -E '/^sh: ?.*(DEPLOY_[A-Z_a-z0-9]+): ?(.*)$/{
s//\n [ERROR] required variable is missing a value\n   Name: \1\n   Info: \2\n   Fix:  add `\1=<your_value>` to deploy.env or deploy-<profile>.env\n/g
w /dev/stderr
d
}'

