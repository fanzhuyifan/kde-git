#!/bin/bash

# Usage: patch_pkgbuild.sh <dir>
# Patches the PKGBUILD in the directory passed as an argument

set -e

echo "Patching $1"

BRANCH="_custom"
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG=$(echo "$1" | sed 's:/*$::')

patch_version() {
    OLD_VER=$(makepkg --printsrcinfo | grep -P '\tpkgver = ' | sed 's/\tpkgver = //g')
    cat <<EOF >>PKGBUILD
pkgver() {
    cd \${srcdir}/\${pkgname}
    echo "${OLD_VER}_\$(git describe --long --tags --abbrev=7 --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//')_\$(printf '%(%Y%m%d)T')"
}
EOF
}

patch_sources() {
    sed -i 's|https://download\.kde\.org/.*\.tar\.xz{,\.sig}|git+https://github.com/KDE/\${pkgname}|g' PKGBUILD
}

patch_other() {
    sed -i 's|\$pkgname-\$pkgver|\$pkgname|g' PKGBUILD
}

patch_custom() {
    PATCH_FILE="$DIR/patches/$PKG.patch"
    if [ -f "$PATCH_FILE" ]; then
        patch -p0 <"$PATCH_FILE"
    fi
}

pushd "$1" 1>/dev/null

REMOTE_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

git reset --hard 1>/dev/null 2>&1
git -c advice.detachedHead=false checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git branch -D "$BRANCH" 1>/dev/null 2>&1 || true
git checkout -b "$BRANCH" 1>/dev/null 2>&1

patch_version
patch_sources
patch_other
patch_custom

popd 1>/dev/null
