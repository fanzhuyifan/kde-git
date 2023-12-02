#!/bin/bash

# Usage: build_install_all.sh <pkg1> <pkg2> <pkg3> ...
# Builds and install all packages passed as arguments
# doing so in the correct order

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
        makepkg -of --skipinteg
        popd 1>/dev/null
    done
fi

BUILD_ORDER=$(get_build_order.sh "$@")
echo "$BUILD_ORDER" | while read -r pkg; do
    echo "Building $pkg"
    pushd "$pkg" 1>/dev/null
    makepkg -sei --noconfirm
    popd 1>/dev/null
done
