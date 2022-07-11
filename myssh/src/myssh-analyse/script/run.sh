#!/bin/sh

while true
do
    echo "[$(date)] scaning..."
    scan.sh 2>/dev/null
    echo "[$(date)] sleeping..."
    sleep 1800
done

