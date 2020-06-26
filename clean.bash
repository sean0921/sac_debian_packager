#!/usr/bin/env bash

set -eu

printf "\033[1m+ Cleaning previous build...\033[0m\n"
test -d pkgroot && rm -r pkgroot
test -e *.deb && rm *.deb
test -e sac-*/ && rm -r sac-*/
printf "\033[1;32m    - Done!\033[0m\n"
