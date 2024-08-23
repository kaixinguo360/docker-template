#!/bin/sh

# Default Params
TEMPLATE_NAME="$(basename "$(realpath "$(dirname "$0")/..")")"
TEMPLATE_PATH="$(realpath "$(dirname "$0")/..")"
if [ -n "$DEPLOY_BACKUP_ROOT" ]; then
    DEFAULT_BACKUP_PATH="$DEPLOY_BACKUP_ROOT/$TEMPLATE_NAME"
else
    DEFAULT_BACKUP_PATH="$(realpath "$(dirname "$0")/../backup")"
fi

# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" -o -z "$*" ]; then
    printf 'Usage: %s <profile> <backup_message =$BACKUP_MSG>\n\t\t      [backup_path =$BACKUP_PATH default=%s]\n\t\t      [backup_time =$BACKUP_TIME default=$(date "%s")]\n' \
        "$(basename "$0")" \
        "$DEFAULT_BACKUP_PATH" \
        "+%Y-%m-%d_%H-%M-%S"
    exit 0
fi

## Backup Begin ##

. "$(dirname "$0")/lib.sh"

printf 'Backuping stack %s...\n' "$DEPLOY_STACK_NAME"

printf '  Preparing Parameters...\n'
[ -z "$1" -a -z "$BACKUP_MSG" ] \
    && printf '[ERROR] Please set the backup_message ($BACKUP_MSG or $1)\n' >&2 && exit 1
BACKUP_MSG="${1:-${BACKUP_MSG}}"
BACKUP_PATH="${2:-${BACKUP_PATH:-$DEFAULT_BACKUP_PATH}}"
BACKUP_TIME=${3:-${BACKUP_TIME:-$(date "+%Y-%m-%d_%H-%M-%S")}}
cat << HERE
    STACK_NAME  = $DEPLOY_STACK_NAME
    BACKUP_MSG  = $BACKUP_MSG
    BACKUP_PATH = $BACKUP_PATH
    BACKUP_TIME = $BACKUP_TIME
HERE
[ -n "$SKIP" ] && printf '    SKIP        = %s\n' "$SKIP"
printf '  done\n'

if [ -z `docker image ls alpine:3 -q` ]; then
    printf '  Pulling tool image alpine:3... '
    docker pull alpine:3 >/dev/null \
        && printf 'ok\n' \
        || exit 1
fi

printf '  Backuping data from %s:%s/%s... ' \
    "$DEPLOY_DATA_HOST" \
    "$DEPLOY_DATA_ROOT" \
    "$DEPLOY_STACK_NAME"
if [ -n "$SKIP" -a -n "$(echo "$SKIP"|grep -E 'data|D')" ]; then
    printf 'skipped\n'
else
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
    docker run --rm -i \
        -v tmp_volume:/data \
        -v "$BACKUP_PATH":/backup \
        alpine:3 sh << HERE || exit 1
    if [ -d '/data/$DEPLOY_STACK_NAME' ]; then
        cd "/data/$DEPLOY_STACK_NAME" \
            && printf '    Packaging... ' \
            && tar -zcpf /tmp/backup.tgz * \
            && printf '%s\n' "\$(du -h /tmp/backup.tgz|awk '{print \$1}')" \
            && printf '    Generating ID... ' \
            && ID="\$(md5sum /tmp/backup.tgz|awk '{print \$1}'|head -c 7)" \
            && printf '%s\n' "\$ID" \
            && printf '    Archiving... ' \
            && BACKUP_NAME="${DEPLOY_STACK_NAME}_[$BACKUP_TIME]_[\$ID]_[$BACKUP_MSG].data.tgz" \
            && mv /tmp/backup.tgz "/backup/\${BACKUP_NAME}" \
            && printf '%s\n' "\$BACKUP_NAME"
    else
        printf '    Packaging... skipped\n'
    fi
HERE
    printf '    Removing tmp volume... '
    docker volume rm -f tmp_volume >/dev/null \
        && printf 'ok\n' \
        || exit 1
    printf '  done\n'
fi

printf "  Backuping config from %s... " "$(realpath "$TEMPLATE_PATH")"
if [ -n "$SKIP" -a -n "$(echo "$SKIP"|grep -E 'config|C')" ]; then
    printf 'skipped\n'
else
    printf '\n'
    docker run --rm -i \
        -v "$(dirname "$TEMPLATE_PATH")":/data \
        -v "$BACKUP_PATH":/backup \
        alpine:3 sh << HERE || exit 1
        cd /data \
            && printf '    Packaging... ' \
            && tar -zcpf /tmp/backup.tgz "$TEMPLATE_NAME" \
            && printf '%s\n' "\$(du -h /tmp/backup.tgz|awk '{print \$1}')" \
            && printf '    Generating ID... ' \
            && ID="\$(md5sum /tmp/backup.tgz|awk '{print \$1}'|head -c 7)" \
            && printf '%s\n' "\$ID" \
            && printf '    Archiving... ' \
            && BACKUP_NAME="${DEPLOY_STACK_NAME}_[${BACKUP_TIME}]_[\${ID}]_[${BACKUP_MSG}].config.tgz" \
            && mv /tmp/backup.tgz "/backup/\${BACKUP_NAME}" \
            && printf '%s\n' "\$BACKUP_NAME"
HERE
    printf '  done\n'
fi

printf 'done\n'

## Backup End ##

