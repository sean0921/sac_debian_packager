#!/bin/sh

SAC_PROGRAM_BASENAME=$(basename $0)
. /opt/sac/bin/sacinit.sh

set -e

case "${SAC_PROGRAM_BASENAME}" in
    "sac")
        exec "/opt/sac/bin/${SAC_PROGRAM_BASENAME}" "$@"
        ;;
    *)
        exec "/opt/sac/bin/${SAC_PROGRAM_BASENAME}" "$@"
        ;;
esac
