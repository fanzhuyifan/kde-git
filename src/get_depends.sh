#!/bin/bash

# Usage: ./get_depends.sh <dir>

pushd "$1" 1>/dev/null

makepkg --printsrcinfo | grep -P "\tdepends = " | sed 's/\tdepends = //g' | sort | uniq

popd 1>/dev/null