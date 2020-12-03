#!/usr/bin/env bash

DEBIAN_PACKAGE_NAME=sac-iris
VERSION=102.0
VERSION_DEBPREFIX=
VERSION_DEBSUFFIX=-1+sdp1.1
MAINTAINER="Sean Ho <sean.li.shin.ho@gmail.com>"
SOURCE_TARBALL_NAME=sac-"$VERSION".tar.gz
SOURCE_REQUIRED_CHECKSUMS="6815c2879d047f1f4961dbd52102ab131faac862661ec6a128ab00575b8abc12"
ARCH=amd64
BUILD_ROOT=$(pwd)

#################################### Phrasing Options
### TO DO: using getopt supports

case "$1" in
    -h|--help)
        printf "SAC Debian/Ubuntu Packager ver ${VERSION_DEBPREFIX}${VERSION}${VERSION_DEBSUFFIX}\n"
        printf "\n"
        printf "usage: \n"
        printf "    -v, --verbose: show more detail message while building\n"
        printf "    -V, --version: show more detail message while building\n"
        printf "    -h, --help: show this help\n"
        printf "    --clean: clean binary and generated data after package building\n"
        printf "\n"
        exit 0
        ;;
    -V|--version)
        printf "SAC Debian/Ubuntu Packager ver ${VERSION_DEBPREFIX}${VERSION}${VERSION_DEBSUFFIX}\n"
        printf "\n"
        exit 0
        ;;
    --clean)
        printf "\033[1m+ Cleaning previous build...\033[0m\n"
        test -d pkgroot && rm -rv pkgroot
        test -e ${DEBIAN_PACKAGE_NAME}-${VERSION_DEBPREFIX}${VERSION}${VERSION_DEBSUFFIX}_${ARCH}.deb \
            && rm -v ${DEBIAN_PACKAGE_NAME}-${VERSION_DEBPREFIX}${VERSION}${VERSION_DEBSUFFIX}_${ARCH}.deb
        test -e sac-${VERSION}/ && rm -rv sac-${VERSION}
        printf "\033[1;32m    - Done!\033[0m\n"
        exit 0
        ;;
    --quiet)
        QUIET="--quiet"
        LN_ARGUMENT="-rs"
        RM_ARGUMENT="-r"
        MKDIR_ARGUMENT="-p"
        AUTORECONF_ARUMENT="-fi"
        ;;
    -v|--verbose|*)
        QUIET=""
        LN_ARGUMENT="-rsv"
        RM_ARGUMENT="-rv"
        MKDIR_ARGUMENT="-pv"
        AUTORECONF_ARUMENT="-fiv"
        ;;
esac

#################################### Function for phrasing OS detections

function check_distribution() {
    DISTRO_NAME=$(grep PRETTY_NAME /etc/os-release|awk -F'=' '{print $2}')
    case $DISTRO_NAME in
        '"Debian GNU/Linux 9 (stretch)"')
            DEPENDENCIES="x11-apps, libncurses5, libreadline7"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"debian9"
            ;;
        '"Debian GNU/Linux 10 (buster)"')
            DEPENDENCIES="x11-apps, libncurses6, libreadline7"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"debian10"
            ;;
        '"Debian GNU/Linux bullseye/sid"')
            DEPENDENCIES="x11-apps, libncurses6, libreadline8"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"debiansid"
            ;;
        '"Ubuntu 16.04'*)
            DEPENDENCIES="x11-apps, libncurses5, libreadline6"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"ubuntu16"
            ;;
        '"Ubuntu 18.04'*)
            DEPENDENCIES="x11-apps, libncurses5, libreadline7"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"ubuntu18"
            ;;
        '"Ubuntu 20.04'*)
            DEPENDENCIES="x11-apps, libncurses6, libreadline8"
            VERSION_DEBSUFFIX=$VERSION_DEBSUFFIX"ubuntu20"
            ;;
        *)
            printf "\033[1;31m   x Sorry, we don't support this distribution for packaging!\033[0m\n"
            exit 1
            ;;
    esac
}

#################################### Main Script Start Here

set -eu

printf "\033[1;36mSAC Debian/Ubuntu Packager ver $VERSION_DEBPREFIX$VERSION$VERSION_DEBSUFFIX\033[0m\n"
printf "\033[1;33m+ Starting Build in $BUILD_ROOT ...\033[0m\n"

#################################### Cleaning previous build for preventing accident error

printf "\033[1m+ Cleaning previous build...\033[0m\n"
test -d pkgroot && rm $RM_ARGUMENT pkgroot
test -e *.deb && rm $RM_ARGUMENT *.deb
test -e sac-"$VERSION" && rm $RM_ARGUMENT sac-"$VERSION"
mkdir $MKDIR_ARGUMENT pkgroot/DEBIAN
mkdir $MKDIR_ARGUMENT pkgroot/usr/bin
mkdir $MKDIR_ARGUMENT pkgroot/usr/share/sac/scripts
mkdir $MKDIR_ARGUMENT pkgroot/etc/profile.d
mkdir $MKDIR_ARGUMENT pkgroot/etc/csh/login.d
mkdir $MKDIR_ARGUMENT pkgroot/opt/sac
printf "\033[1;32m    - Done!\033[0m\n"

#################################### Checking whether the source code is right or wrong

printf "\033[1m+ Checking source tarball ( $PWD/$SOURCE_TARBALL_NAME )...\033[0m\n"
( test -e "$SOURCE_TARBALL_NAME" && (>&2 printf "\033[1;32m    - Tarball exists!\033[0m\n") ) ||
    ( printf "\033[1;31m   x Tarball does not exist or filename was wrong!\033[0m\n" && exit 1)
sha256_this_tarball=$(sha256sum $SOURCE_TARBALL_NAME | awk '{print $1}')
( test "$SOURCE_REQUIRED_CHECKSUMS" = "$sha256_this_tarball" && (>&2 printf "\033[1;32m    - Tarball checksums is right!\033[0m\n") ) ||
    ( printf "\033[1;31m   x Tarball's checksums was wrong! Maybe you use the wrong file.\033[0m\n" && exit 1)

printf "\033[1m+ Extracting...\033[0m\n"
tar -zxf "$SOURCE_TARBALL_NAME"
printf "\033[1;32m    - Done!\033[0m\n"

#################################### Configuring for later compiling...

printf "\033[1m+ Preparing for configuration...\033[0m\n"
cd "$BUILD_ROOT"/sac-"$VERSION"
patch $QUIET -p1 < ../0001-refresh-DESTDIR-fix-patch.patch
autoreconf $AUTORECONF_ARUMENT
./configure --prefix="/opt/sac" --enable-readline $QUIET
printf "\033[1;32m    - Done!\033[0m\n"

#################################### Building SAC...

printf "\033[1m+ Compiling...\033[0m\n"
make -j$(nproc) $QUIET
printf "\033[1;32m    - Done!\033[0m\n"

#################################### Installing SAC to package root

printf "\033[1;32m+ Adding program to distro path...\033[0m\n"
make DESTDIR="$BUILD_ROOT"/pkgroot $QUIET install
cd "$BUILD_ROOT"
ln $LN_ARGUMENT pkgroot/opt/sac/bin/sac pkgroot/usr/bin/sac
ln $LN_ARGUMENT pkgroot/opt/sac/bin/sacinit.sh pkgroot/etc/profile.d/sac_bash_profile.sh
ln $LN_ARGUMENT pkgroot/opt/sac/bin/sacinit.csh pkgroot/etc/csh/login.d/sacinit.csh

#################################### Writing suitable information to packaging file

printf "\033[1;32m+ Generating Debian/Ubuntu packaging control file...\033[0m\n"
check_distribution
cat > pkgroot/DEBIAN/control <<EOF
Package: $DEBIAN_PACKAGE_NAME
Version: $VERSION_DEBPREFIX$VERSION$VERSION_DEBSUFFIX
Section: utils
Priority: optional
Maintainer: $MAINTAINER
Architecture: $ARCH
Depends: $DEPENDENCIES
Homepage: https://ds.iris.edu/ds/nodes/dmc/software/downloads/sac/
Description: 
 Debian/Ubuntu format package for Seismic Analysis Code by IRIS
 This package is generated by third party packaging scripts
 Distributions of binary or source code are restricted by IRIS.
 You can **NOT** upload this binary package in public.
 To get the related source code or binary builds from IRIS,
 you have to request it from: http://ds.iris.edu/ds/nodes/dmc/forms/sac/
 - Source repository of this script: https://github.com/sean0921/sac_debian_packager.git
EOF

#################################### Using prepared package root and control file to build a simple package in unformal debian format

printf "\033[1;32m+ Use dpkg-deb to generate Debian/Ubuntu package...\033[0m\n"
printf "    \033[1;33m+ Packaging in fakeroot mode.....\033[0m\n"
fakeroot dpkg-deb --build pkgroot "$DEBIAN_PACKAGE_NAME"-""$VERSION_DEBPREFIX"$VERSION""$VERSION_DEBSUFFIX"_"$ARCH".deb
