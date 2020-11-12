#!/bin/bash

# Default params #
BACKUP_ROOT=${DEPLOY_BACKUP_ROOT:-/srv/backup}

# Change workdir #
cd $(dirname $0)

# Main #
main() {
    printf "Backuping '$1'... "
    backup_time=$(date "+%Y%m%d_%H%M%S")
    [ ! -d "./$1" ] \
        && echo "No such service: $1" >&2 \
        && return 0
    mkdir -p $BACKUP_ROOT/$1 \
        && sudo tar -czpf $BACKUP_ROOT/$1/.tmp.$1_$backup_time.tar.gz ./$1 \
        && sudo chown $UID:$GROUPS $BACKUP_ROOT/$1/.tmp.$1_$backup_time.tar.gz \
        && mv $BACKUP_ROOT/$1/.tmp.$1_$backup_time.tar.gz $BACKUP_ROOT/$1/$1_$backup_time.tar.gz \
        && printf "done.\n"
}

# Print Info #
printf "BACKUP_ROOT=$BACKUP_ROOT\n"

# Preset Mode: All #
if [ "$*" = "--all" ]; then
    running_stacks=$(ls -1)
    [ -n "$running_stacks" ] \
        && set $running_stacks \
        || return 0
fi

# Preset Mode: Running #
if [ "$*" = "--running" ]; then
    running_stacks=$(docker stack ls --format "{{.Name}}")
    [ -n "$running_stacks" ] \
        && set $running_stacks \
        || return 0
fi

# Backup #
for arg in "$@"
do
    main "$arg"
done
