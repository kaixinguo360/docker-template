#!/bin/sh

wget https://github.com/ronggang/transmission-web-control/archive/refs/tags/v1.6.1-update1.zip \
    -O /tmp/transmission-web-control.zip
unzip /tmp/transmission-web-control.zip "transmission-web-control-1.6.1-update1/src/*" -d ./
mv ./transmission-web-control-1.6.1-update1/src/* ./
rm -rf ./transmission-web-control-1.6.1-update1/

