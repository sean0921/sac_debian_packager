# SAC Debian/Ubuntu Package Creator

* **NOTE: Because of LICENSE restriction, this repository does NOT provide IRIS's SAC source code for you.  You have to APPLY and download sources tarball on your own if you have related qualifications!**

## Benefits

* Let install and uninstall steps more cleanly (NO MORE `sudo make install`!  It will mess up your system!)
* After installation, you don't have to manually set environment variables or `source` anything by yourself!

## Use Steps

### Install Dependencies

```
apt install build-essential libx11-dev libncurses-dev libreadline-dev  ### with root
```

### Run build scripts

change your current directory to this source code repo and:

```bash
./build.bash           ## or you can type bash build.bash
```

### Install generated DEB file

```bash
apt install ./sac-iris-*_amd64.deb    #### with root
```

### Done!
