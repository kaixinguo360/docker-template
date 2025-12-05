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
} | {
sh << _____HERE_____
cat << ____HERE____
$(cat)
____HERE____
_____HERE_____
}

