#!/bin/sh

# Change Working Directory
cd $(dirname $0)/..

# Default Params
STACK_NAME="$(basename $(realpath $(pwd)))"
if [ -n "$DEPLOY_BACKUP_ROOT" ]; then
    DEFAULT_PACK_PATH="$DEPLOY_BACKUP_ROOT/$STACK_NAME"
else
    DEFAULT_PACK_PATH="$(realpath $(pwd)/..)"
fi

# Display Help Information
if [ "$1" = "-h" -o "$1" = "--help" ]; then
    printf "Usage: %s <message> [path (default=$DEFAULT_PACK_PATH)]\n" $(basename $0)
    exit 0
fi

# Reaad Args
if [ -z "$1" ]; then
    echo "Please enter the commit message for your package." >&2
    exit 1
fi
PACK_MSG="$1"
PACK_PATH="${2:-$DEFAULT_PACK_PATH}"
PACK_TIME=$(date "+%Y%m%d_%H%M%S")
TMP_PATH="/tmp"
TMP_NAME=".tmp.${STACK_NAME}_${PACK_TIME}_${PACK_MSG}.stack.tar"

printf "Packing... " \
    && cd $(dirname $(realpath $(pwd))) \
    && mkdir -p "$PACK_PATH" \
    && printf "\b\b\b\b, name: $STACK_NAME... " \
    && sudo tar -cpf "$TMP_PATH/${TMP_NAME}" ./$STACK_NAME \
    && sudo chown $UID:$GROUPS "$TMP_PATH/${TMP_NAME}" \
    && printf "\b\b\b\b, size: %s... " $(du -h "$TMP_PATH/${TMP_NAME}"|awk '{print $1}') \
    && ID=$(md5sum "$TMP_PATH/${TMP_NAME}"|awk '{print $1}'|head -c 7) \
    && printf "\b\b\b\b, id: $ID... " \
    && PACK_NAME="${STACK_NAME}_${PACK_TIME}_${ID}_${PACK_MSG}.stack.tar" \
    && sudo mv "$TMP_PATH/${TMP_NAME}" "$PACK_PATH/${PACK_NAME}" \
    && printf "\b\b\b\b, msg: $PACK_MSG... " \
    && printf '\b\b\b\b, done.\n'

