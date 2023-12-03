# About

This repository contains scripts to build and install KDE packages from source on Arch Linux, by automatically fetching and modifying the official PKGBUILDs.

The packages are versioned as `<arch-version>_<tag>.r<revision>.g<commit>_<yyyymmdd>`.
Hence, the package versions are always newer than the official packages, and they automatically follow the versioning of the official packages.

**_WARNING:_** Always make backups before updating your system!

# Preparation

## Install dependencies

```bash
sudo pacman -S devtools parallel
```

- [devtools](https://archlinux.org/packages/extra/any/devtools/)
- [parallel](https://archlinux.org/packages/extra/any/parallel/)

## Setting up chroot

Building the packages in a chroot is strongly recommended.
The packages should be installed at the same time, when all of them have been built successfully.
```bash
source src/prefix.sh
mkarchroot -C <pacman.conf> -M <makepkg.conf> $CHROOT/root base-devel devtools parallel
arch-nspawn $CHROOT/root useradd $USER
sudo bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' >> $CHROOT/root/etc/sudoers"
arch-nspawn $CHROOT/root bash -c "mkdir -p /home/$USER/build; chown -R $USER:$USER /home/$USER"
sudo cp -r src $CHROOT/root/home/$USER
arch-nspawn $CHROOT/root bash
```

## Setting up local repository

If you set up `PKGDEST` in `makepkg.conf` (in the chroot), you can also turn the directory into a local repository by running 
```bash
repo-add $PKGDEST/<repo-name>.db.tar.gz $PKGDEST/*.pkg.tar.zst
```
Then, you can add the repository to `/etc/pacman.conf` by adding the following lines before all the other repositories:
```
[<repo-name>]
SigLevel = Optional TrustAll
Server = file://<path-to-pkgdest>
```

**_TIP:_** The old packages can be cleaned by running
```bash
paccache -c $PKGDEST -k 1 -r
```

# Usage

## Common usage

```bash
mkdir build; cd build
source ../src/prefix.sh
```

See all local packages that are available:
```bash
get_local_packages.sh | tee local_packages.txt
```

Find the correct order of building the packages:
```bash
get_build_order.sh $(cat local_packages.txt) | tee local_build_order.txt
```

Build all local packages:
```bash
build_install_all.sh $(cat local_build_order.txt)
```
It is recommended to use the environment variables documented below to perform the build process step by step.

**_TIP:_**
You can use the environment variable `CMAKE_BUILD_PARALLEL_LEVEL` to control the number of parallel builds.

## build_install_all.sh

This script will build and install all packages passed as arguments in the order they are passed.
The following environment variables can be set to skip certain steps:
- `SKIP_FETCH`: skip fetching the PKGBUILD
- `SKIP_PATCH`: skip patching the PKGBUILD
- `SKIP_PREPARE`: skip preparing the package sources
- `SKIP_BUILD`: skip building and installing the package
