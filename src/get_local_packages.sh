#!/bin/bash

# Prints all installed KDE packages

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
comm -12 <(pacman -Qq | sort) "$DIR"/pkglist.txt
