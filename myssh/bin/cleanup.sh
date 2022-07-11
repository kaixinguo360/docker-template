#!/bin/sh

. $(dirname $0)/lib.sh

# Wait for Confirm
printf 'Destory stack %s...\n' "$DEPLOY_STACK_NAME"
read -p "Continue? [Y/n] " input
case "$input" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) exit 0;;
esac

read -p "Please input the stack name: " input
if [ "$input" = "$DEPLOY_STACK_NAME" ];then
    printf 'OK\n'
else
    printf 'Aborted\n'
    exit 0
fi

## Cleanup Begin ##

printf 'Cleaning data volume... '
if [ -d './var' ]; then
    printf '\n' 

    printf '  Preparing tmp volume... '
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
        printf '  Pulling tool image alpine:3... '
        docker pull alpine:3 >/dev/null \
            && printf 'ok\n' \
            || exit 1
    fi

    printf '  Removing data dir... '
    docker run --rm -v tmp_volume:/data alpine:3 \
        sh -c "rm -rf /data/$DEPLOY_STACK_NAME" \
        && printf 'ok\n' \
        || exit 1

    printf '  Removing tmp volume... '
    docker volume rm -f tmp_volume >/dev/null \
        && printf 'ok\n' \
        || exit 1
else
    printf 'skipped\n'
fi

printf 'done\n'
## Deploy End ##

