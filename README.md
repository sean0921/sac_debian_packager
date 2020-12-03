# SAC Debian/Ubuntu Packager

* **NOTE: Because of LICENSE restriction, this repository does NOT provide IRIS' SAC source code or binary packages for you.  You have to APPLY and download sources tarball on your own if you have related qualifications!**
    - Official software request page: http://ds.iris.edu/ds/nodes/dmc/forms/sac/

![](https://github.com/sean0921/sean0921.github.io/raw/3ef1e32d61fc62c546c6ba31ef526ccc050cc7b2/images/demo.gif)

## Benefits

* Let installing and uninstalling steps more cleanly (NO MORE `sudo make install`!  It will mess up your system!)
* After installation, you don't have to manually set environment variables or `source` anything by yourself!

## Supported Linux Distribution

* Debian Stretch (9/oldstable)
* Debian Buster (10/stable)
* Debian Sid (bulleye/sid)
* Ubuntu Xenial Xerus (16.04)
* Ubuntu Bionic Beaver (18.04)
* Ubuntu Focal Fossa (20.04)

## Supported Shell for Profile Installation

* `bash`
* `csh`/`tcsh`

## How to use this script

* If you know what [docker](https://www.docker.com/) is, it is suggested to use it or create new clean container/chroot to simplify your build environment.

### Install `git` and clone this repository

```bash
apt update       ### with root
apt install git  ### with root
git clone https://github.com/sean0921/sac_debian_packager.git sac_debian_packager
```

or you can download [current `*.zip` archive of this repository](https://github.com/sean0921/sac_debian_packager/archive/master.zip) and extract it.

### Put downloaded SAC source tarball into cloned repo

```bash
cd sac_debian_packager
cp $LOCATION_OF_DOWNLOADED_TARBALL ./              ## For example, cp ~/Download/sac-101.6a-source.tar.gz ./
```

### Install build dependencies

```bash
apt install build-essential libx11-dev libncurses-dev libreadline-dev autoconf automake autopoint autotools-dev ### with root
```

### Run build scripts

change your current directory to this source code repo and:

```bash
./build.bash                          ## or you can type bash build.bash
```

### Install generated `*.deb` file

```bash
apt install ./sac-iris-*_amd64.deb    #### with root, you can change * to specific version number
```

### Done!

* Maybe you have to re-login the shell (for e.g., `bash -l`) or desktop for loading newer environment.

### Remove installed SAC package

```bash
apt remove sac-iris      ### with root
```

### Clean Build Directory before Rebuild

```bash
./build.bash --clean
```

## To Do

* Adding build dependencies package installing procedure to `build.bash`.
* ~~Add patch to fix wrong autoconf name (`configure.in` should be `configure.ac`), simplified duplicated patch.~~ (upstream fixed)
* ~~Pass the compilaion with `-fno-common` mode~~ (upstream fixed)
