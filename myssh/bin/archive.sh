#!/bin/sh

# Default Params
TEMPLATE_NAME="$(basename $(realpath $(dirname $0)/..))"
TEMPLATE_PATH="$(realpath $(dirname $0)/..)"
if [ -n "$DEPLOY_BACKUP_ROOT" ]; then
    DEFAULT_BACKUP_PATH="$DEPLOY_BACKUP_ROOT/$TEMPLATE_NAME"
else
    DEFAULT_BACKUP_PATH="$(realpath $(dirname $0)/../backup)"
fi

# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" -o -z "$*" ]; then
    printf 'Usage: %s <profile> \n\t\t  [backup_message =$BACKUP_MSG default=%s]\n\t\t  [backup_path =$BACKUP_PATH default=%s]\n\t\t  [backup_time =$BACKUP_TIME default=$(date "%s")]\n' \
        "$(basename $0)" \
        "archive" \
        "$DEFAULT_BACKUP_PATH" \
        "+%Y-%m-%d_%H-%M-%S"
    exit 0
fi

. $(dirname $0)/lib.sh

BACKUP_MSG="${1:-${BACKUP_MSG:-archive}}"

## Archive Begin ##

printf 'Archiving data... '
if [ -d './var' ]; then
    printf '\n' 

    #./bin/data-backup.sh "$PROFILE" "$BACKUP_MSG" 2>&1 | sed 's/^/  /g' || exit 1

    printf '  Cleaning volume... '
    if [ -d './var' ]; then
        printf '\n' 

        printf '    Preparing tmp volume... '
        docker volume rm -f tmp_volume >/dev/null || exit 1
        docker volume create tmp_volume \
            --driver local \
            -o "type=nfs" \
            -o "o=addr=$DEPLOY_DATA_HOST,nolock,soft,rw" \
            -o "device=:$DEPLOY_DATA_ROOT" \
            >/dev/null \
            && printf 'ok\n' \
            || exit 1

        if [ -z `docker image ls alpine:3 -q` ]; then
            printf '    Pulling tool image alpine:3... '
            docker pull alpine:3 >/dev/null \
                && printf 'ok\n' \
                || exit 1
        fi

        printf '    Deleting data dir... '
        docker run --rm -v tmp_volume:/data alpine:3 \
            sh -c "rm -r -f /data/$DEPLOY_STACK_NAME" \
            && printf 'ok\n' \
            || exit 1

        printf '    Removing tmp volume... '
        docker volume rm -f tmp_volume >/dev/null \
            && printf 'ok\n' \
            || exit 1

        printf '  done\n'
    else
        printf 'skipped\n'
    fi
else
    printf 'skipped\n'
fi

printf 'done\n'

## Archive End ##

