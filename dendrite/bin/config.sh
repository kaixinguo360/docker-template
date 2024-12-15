#!/bin/sh

. "$(dirname "$0")/lib.sh"

cat docker-compose.yml | {
    if [ -n "$DEPLOY_ENABLED_FEATURE" ]; then
        sed -E "s/^#:($DEPLOY_ENABLED_FEATURE)(\s*\||\s+)(.*)$/\\3/g" | \
        sed -E "s/^#:($DEPLOY_ENABLED_FEATURE)(\s*\||\s+)(.*)$/\\3/g" | \
        sed -E "s/^(.*)\s*#!($DEPLOY_ENABLED_FEATURE)\s*($|#!)/#\\1/g"
    else
        cat
    fi
}

