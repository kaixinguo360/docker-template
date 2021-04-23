#!/bin/sh

# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" -o -z "$*" ]; then
    printf 'Usage: %s <profile> <backup_file =$BACKUP_FILE>\n' \
        "$(basename $0)"
    exit 0
fi

## Restore Begin ##

. $(dirname $0)/lib.sh

printf 'Restoring stack %s...\n' "$DEPLOY_STACK_NAME"

printf '  Preparing Parameters...\n'
[ -z "$1" -a -z "$BACKUP_FILE" ] \
    && printf '[ERROR] Please set the backup_file (\$BACKUP_FILE or \$1)\n' >&2 && exit 1
BACKUP_FILE="${1:-$BACKUP_FILE}"
cat << HERE
    STACK_NAME  = $DEPLOY_STACK_NAME
    BACKUP_FILE = $BACKUP_FILE
  done
HERE

read -p "  Continue? [Y/n] " input
case "$input" in
    [Yy]|[Yy][Ee][Ss]) ;;
    *) exit 0;;
esac

if [ -z `docker image ls alpine:3 -q` ]; then
    printf '  Pulling tool image alpine:3... '
    docker pull alpine:3 >/dev/null \
        && printf 'ok\n' \
        || exit 1
fi

printf '  Restoring data to %s:%s/%s...\n' \
    "$DEPLOY_DATA_HOST" \
    "$DEPLOY_DATA_ROOT" \
    "$DEPLOY_STACK_NAME"
printf '    Checking file... ' \
    && [ -e "$BACKUP_FILE" ] \
    && printf 'ok\n' \
    || { printf 'not found\n'; exit 1; }
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
printf '    Untaring... '
docker run --rm \
    -v tmp_volume:/data \
    -v "$BACKUP_FILE":/backup.tar.gz \
    alpine:3 sh -c "
    if [ ! -d '/data/$DEPLOY_STACK_NAME' ]; then
      mkdir '/data/$DEPLOY_STACK_NAME'
      tar -zxpf /backup.tar.gz -C /data/$DEPLOY_STACK_NAME
      printf 'ok\n'
    else
      printf 'exists, interrupted\n'
    fi" \
    || exit 1
printf '    Removing tmp volume... '
docker volume rm -f tmp_volume >/dev/null \
    && printf 'ok\n' \
    || exit 1
printf '  done\n'

printf 'done\n'

## Restoring End ##

