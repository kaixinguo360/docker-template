#!/bin/sh

. $(dirname $0)/lib.sh

cat << HERE

--------
 README
--------

Before using this app, you should set the password of admin user

  # generate a random password
  docker exec -it <alist_container_id> ./alist admin random

  # or set a password manually
  docker exec -it <alist_container_id> ./alist admin set <new_password>

Full documentation at: <https://alist.nn.ci/zh/guide/install/docker.html>

HERE

