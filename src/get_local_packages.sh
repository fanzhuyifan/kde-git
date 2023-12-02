#!/bin/bash

# Prints all installed KDE packages

comm -12 <(pacman -Qq | sort) <(get_pkglist.sh 2>/dev/null | sort)
