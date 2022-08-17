#!/bin/sh
set -e
. /opt/sac/bin/sacinit.sh
exec /opt/sac/bin/sac "$@"
