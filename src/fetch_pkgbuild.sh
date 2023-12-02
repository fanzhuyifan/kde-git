#!/bin/bash

# Usage: fetch_pkgbuild.sh <package_name>

# This script is used to fetch the latest PKGBUILD from Arch Linux's
# git repository. It will use the latest tagged version of the PKGBUILD

set -e

BRANCH="makepkg"

pkgctl repo clone --protocol https "$1"
cd "$1"
REMOTE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

git reset --hard 1>/dev/null 2>&1
git checkout "$REMOTE_BRANCH"
git pull
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git branch -D "$BRANCH" 1>/dev/null 2>&1
git checkout -b "$BRANCH" 1>/dev/null 2>&1

cd ..
