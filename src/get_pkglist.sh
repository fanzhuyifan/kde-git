#!/usr/bin/env bash

# This script prints the list of packages for KDE software
# that this tool attempts to build.

fetch_pkgbuild.sh plasma-meta 1>/dev/null
fetch_pkgbuild.sh kde-applications-meta 1>/dev/null

get_depends.sh plasma-meta | grep -v '\-meta$'
get_depends.sh kde-applications-meta | grep -v '\-meta$'
