# About

This repository contains scripts to build and install KDE packages from source on Arch Linux, by automatically fetching and modifying the official PKGBUILDs.

# Usage

## Setting up chroot

You are advised to build the packages in a chroot, and only install them on your system after they have been built successfully.
```bash
source src/prefix.sh
mkarchroot -C <pacman.conf> -M <makepkg.conf> $CHROOT/root base-devel devtools parallel
arch-nspawn $CHROOT/root useradd $USER
sudo bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' >> $CHROOT/root/etc/sudoers"
arch-nspawn $CHROOT/root bash -c "mkdir -p /home/$USER/build; chown -R $USER:$USER /home/$USER"
sudo cp -r src $CHROOT/root/home/$USER
arch-nspawn $CHROOT/root bash
```

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
You can use the environment variable `CMAKE_BUILD_PARALLEL_LEVEL` to control the number of parallel builds.

## build_install_all.sh

This script will build and install all packages passed as arguments in the order they are passed.
The following environment variables can be set to skip certain steps:
- `SKIP_FETCH`: skip fetching the PKGBUILD
- `SKIP_PATCH`: skip patching the PKGBUILD
- `SKIP_PREPARE`: skip preparing the package sources
- `SKIP_BUILD`: skip building and installing the package

# Dependencies:

- devtools
- parallel
