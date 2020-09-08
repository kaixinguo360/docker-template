#!/bin/sh

cd $(dirname $0)

[ -z "$MYSSH_LOG_PATH" ] && \
    MYSSH_LOG_PATH='/var/openssh/log/sshd-pw.log'
[ -z "$MYSSH_ARCH_PATH" ] && \
    MYSSH_ARCH_PATH="/var/openssh/archive"

[ ! -f "$MYSSH_LOG_PATH" ] \
    && echo '[INFO] No log file of myssh to commit.' \
    && exit 0

TMP_PATH="$MYSSH_LOG_PATH.tmp"
mv $MYSSH_LOG_PATH $TMP_PATH

awk -f to-mysql.awk -v table=passwords $TMP_PATH | mysql-cli.sh

mkdir -p $MYSSH_ARCH_PATH
cat $TMP_PATH >> $MYSSH_ARCH_PATH/$(date '+%Y-%m-%d').log

./update-ips.sh
