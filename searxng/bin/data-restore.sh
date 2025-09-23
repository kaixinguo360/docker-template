#!/bin/sh

# Default Params
TEMPLATE_NAME="$(basename "$(realpath "$(dirname "$0")/..")")"
if [ -n "$DEPLOY_BACKUP_ROOT" ]; then
    DEFAULT_BACKUP_PATH="$DEPLOY_BACKUP_ROOT/$TEMPLATE_NAME"
else
    DEFAULT_BACKUP_PATH="$(realpath "$(dirname "$0")/../backup")"
fi

# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" -o -z "$*" ]; then
    printf 'Usage: %s <profile> <backup_file =$BACKUP_FILE>\n' "$(basename "$0")"
    printf '       %s <profile> <backup_id =$BACKUP_ID>\n\t\t       [backup_path =$BACKUP_PATH default=%s]\n' \
        "$(basename "$0")" \
        "$DEFAULT_BACKUP_PATH"
    exit 0
fi

## Restore Begin ##

. "$(dirname "$0")/lib.sh"

printf 'Restoring stack %s...\n' "$DEPLOY_STACK_NAME"

printf '  Preparing Parameters...\n'
if [ -z "$1" -a -z "$BACKUP_FILE" -a -z "$BACKUP_ID" ]; then
    printf '[ERROR] Please set the backup_file or backup_id ($BACKUP_FILE, $BACKUP_ID or $1)\n' >&2
    exit 1
fi
printf '    STACK_NAME  = %s\n' "$DEPLOY_STACK_NAME"
if [ -n "$(echo "$1"|grep -E '^.*\.(tar\.gz|tar|gz|tgz)$')" ]; then
    BACKUP_FILE="${1:-$BACKUP_FILE}"
    printf '    BACKUP_FILE = %s\n' "$BACKUP_FILE"
else
    BACKUP_ID="${1:-$BACKUP_ID}"
    BACKUP_PATH="${BACKUP_PATH:-$DEFAULT_BACKUP_PATH}"
    printf '    BACKUP_ID   = %s\n' "$BACKUP_ID"
    printf '    BACKUP_PATH = %s\n' "$BACKUP_PATH"
fi
printf '  done\n'

printf '  Checking file... '
if [ -n "$BACKUP_ID" ]; then
    BACKUP_FILE="$(find "$BACKUP_PATH" -type f -name "*$BACKUP_ID*" \
        | grep -E '^.*\.(tar\.gz|tar|gz|tgz)$' \
        | grep -Ev '^.*.config\.(tar\.gz|tar|gz|tgz)$')" 2>/dev/null
    COUNT="$(echo "$BACKUP_FILE" | wc -l)"
    if [ -z "$BACKUP_FILE" ]; then
        printf 'not found\n'
        exit 1
    elif [ "$COUNT" = 1 ]; then
        printf '%s\n' "$BACKUP_FILE"
        read -p "  Continue? [Y/n] " input
        case "$input" in [Yy]|[Yy][Ee][Ss]) ;; *) exit 0;; esac
    else
        printf '\n'
        echo "$BACKUP_FILE" | cat -n | expand -t1 | tr -s '[:space:]' | sed 's/^/   /g'
        read -p "  Which one? [1-$COUNT] " input
        [ "$input" -le "$COUNT" -a "$input" -gt '0' ] 2>/dev/null || exit 0
        BACKUP_FILE="$(echo "$BACKUP_FILE" | head -n "${input}" | tail -n1)" 2>/dev/null
        [ -z "$BACKUP_FILE" ] && exit 0
    fi
else
    if [ -e "$BACKUP_FILE" ]; then
        printf 'ok\n'
        read -p "  Continue? [Y/n] " input
        case "$input" in [Yy]|[Yy][Ee][Ss]) ;; *) exit 0;; esac
    else
        printf 'not found\n'
        exit 1
    fi
fi

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
    -v "$BACKUP_FILE":/backup.tgz \
    alpine:3 sh -c "
    if [ ! -d '/data/$DEPLOY_STACK_NAME' ]; then
      mkdir '/data/$DEPLOY_STACK_NAME'
      tar -zxpf /backup.tgz -C "/data/$DEPLOY_STACK_NAME"
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

