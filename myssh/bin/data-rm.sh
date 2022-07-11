#!/bin/bash

cd $(dirname $0)/..

ID="$1"

FILES="$(ls -hl ${DEPLOY_BACKUP_ROOT?}/$(basename $(realpath $(pwd)))/* \
    | awk '{print $9" "$5" "$9}' \
    | sed -E \
        -e 's/\.data\.(tar\.gz|tar|gz|tgz) /.D.\1 /' \
        -e 's/\.config\.(tar\.gz|tar|gz|tgz) /.C.\1 /' \
    | sed -En 's/.*\/([^\/]+)_\[(.*)\]_\[(.*)\]_\[(.*)\]\.([A-Z])+\.(tar\.gz|tar|gz|tgz) ([^ ]*) (.*)$/\3 \2 \7 \5 \1 \4 \8/p' \
    | sort --k 2,2 -k 5,5 -k 4,4 \
    | cat -n \
    | grep -E '^\s*'"${ID}"'\s+' \
    | awk '{print $8}'
)"

if [ -z "$FILES" ]; then
    printf 'No such ID: %s\n' "$ID"
    exit 0;
fi

# Wait for Confirm
printf 'Files to remove: \n'
printf '%s\n' "$FILES" | cat -n
read -p "Continue? [Y/n] " input
case "$input" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) exit 0;;
esac

rm -f $FILES

