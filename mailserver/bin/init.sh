#!/bin/sh

. $(dirname $0)/lib.sh

cat << HERE

--------
 README
--------

Before using this app, you should download a administration script, which helps with the most common tasks, including initial configuration.

The latest version of the script can be download by these commands:

  + wget https://raw.githubusercontent.com/docker-mailserver/docker-mailserver/master/setup.sh
  + chmod a+x ./setup.sh

Full documentation at: <https://docker-mailserver.github.io/docker-mailserver/v10.0>

HERE

