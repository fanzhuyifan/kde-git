#!/bin/bash

# Usage: ./build_install_all.sh <pkg1> <pkg2> <pkg3> ...
# Builds and install all packages passed as arguments
# doing so in the correct order

# fetch the PKGBUILDs
for pkg in "$@"; do
    fetch_pkgbuild.sh "$pkg"
done

# patch the PKGBUILDs
for pkg in "$@"; do
    patch_pkgbuild.sh "$pkg"
done

# extract sources and prepare build
for pkg in "$@"; do
    pushd "$pkg" 1>/dev/null
    makepkg -of --skipinteg
    popd 1>/dev/null
done
