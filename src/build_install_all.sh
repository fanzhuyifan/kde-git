#!/usr/bin/env bash

# Usage: build_install_all.sh <pkg1> <pkg2> <pkg3> ...
# Builds and install all packages passed as arguments in order

set -e

# fetch the PKGBUILDs
if [ -z "$SKIP_FETCH" ]; then
    for pkg in "$@"; do
        fetch_pkgbuild.sh "$pkg"
    done
fi

# patch the PKGBUILDs
if [ -z "$SKIP_PATCH" ]; then
    parallel -j $(nproc) patch_pkgbuild.sh ::: "$@"
fi

# extract sources and prepare build
if [ -z "$SKIP_PREPARE" ]; then
    for pkg in "$@"; do
        pushd "$pkg" 1>/dev/null
        makepkg -ofs --skipinteg --noconfirm
        popd 1>/dev/null
    done
fi

if [ -z "$SKIP_BUILD" ]; then
    for pkg in "$@"; do
        echo "Building $pkg"
        pushd "$pkg" 1>/dev/null
        makepkg -fsei --noconfirm
        popd 1>/dev/null
    done
fi
