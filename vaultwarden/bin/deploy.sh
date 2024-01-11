#!/bin/sh

. "$(dirname "$0")/lib.sh"

# Show Deploy Info
printf '+ %s\n' "./bin/info.sh $PROFILE"
printf '========================================'
printf '========================================\n'
./bin/info.sh "$PROFILE" 2>&1
printf '========================================'
printf '========================================\n'

# Wait for Confirm
printf 'Deploying stack %s...\n' "$DEPLOY_STACK_NAME"
read -p "Continue? [Y/n] " input
case "$input" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) exit 0;;
esac


## Deploy Begin ##

printf 'Initing data volume... '
if [ -d './volume' ]; then
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

    printf '  Creating data dir at %s:%s/%s... ' \
        "$DEPLOY_DATA_HOST" \
        "$DEPLOY_DATA_ROOT" \
        "$DEPLOY_STACK_NAME"
    docker run --rm \
        -v tmp_volume:/data \
        -v "$(realpath ./volume)":/template \
        alpine:3 sh -c "
        if [ ! -d '/data/$DEPLOY_STACK_NAME' ]; then
          cp -Ta /template '/data/$DEPLOY_STACK_NAME'
          printf 'ok\n'
        else
          printf 'skipped\n'
        fi" \
        || exit 1

    printf '  Cleaning gitkeep file in data dir... '
    docker run --rm -v tmp_volume:/data alpine:3 \
        sh -c "rm -f '/data/$DEPLOY_STACK_NAME/*/.gitkeep'" \
        && printf 'ok\n' \
        || exit 1

    printf '  Removing tmp volume... '
    docker volume rm -f tmp_volume >/dev/null \
        && printf 'ok\n' \
        || exit 1
else
    printf 'skipped\n'
fi

printf 'Initing stack with bin/init.sh... '
if [ -x "./bin/init.sh" ]; then
    printf '\n' 
    ./bin/init.sh "$PROFILE" 2>&1 | sed 's/^/  /g' || exit 1
else
    printf 'skipped\n'
fi

printf 'done\n'
## Deploy End ##

