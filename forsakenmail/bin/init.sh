#!/bin/sh

. $(dirname $0)/lib.sh

cat << HERE

--------
 README
--------

Before using this app, you should set up your DNS correctly

First an MX record:
  subdomain.domain.com MX 10 mxsubdomain.domain.com.
Then an A record:
  mxsubdomain.domain.com A the.ip.address.of.your.mailin.server.

Full documentation at: <https://github.com/denghongcai/forsaken-mail>

HERE

