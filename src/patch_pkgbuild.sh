#!/bin/bash

# Usage: patch_pkgbuild.sh <dir>
# Patches the PKGBUILD in the directory passed as an argument

patch_version() {
    OLD_VER=$(makepkg --printsrcinfo | grep -P '\tpkgver = ' | sed 's/\tpkgver = //g')
    cat <<EOF >>PKGBUILD
pkgver() {
    cd \${srcdir}/\${pkgname}
    echo "${OLD_VER}_\$(git describe --long --tags --abbrev=7 | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//')_\$(printf '%(%Y%m%d)T')"
}
EOF
}

patch_sources() {
    sed -i 's|https://download\.kde\.org/.*\.tar\.xz{,\.sig}|git+https://github.com/KDE/\${pkgname}|g' PKGBUILD
}

patch_other() {
    sed -i 's|\$pkgname-\$pkgver|\$pkgname|g' PKGBUILD
}

pushd "$1" 1>/dev/null

patch_version
patch_sources
patch_other

popd 1>/dev/null
