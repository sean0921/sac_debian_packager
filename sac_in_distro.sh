#!/bin/sh
set -e
. /opt/sac/bin/sacinit.sh
exec /opt/sac/bin/sac /opt/sac/macros/qdp_off.m "$@"
