#!/bin/bash

# Usage: fetch_pkgbuild.sh <package_name>

# This script is used to fetch the latest PKGBUILD from Arch Linux's
# git repository. It will use the latest tagged version of the PKGBUILD

BRANCH="makepkg"

pkgctl repo clone --protocol https "$1"
cd "$1"
REMOTE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')

git reset --hard
git checkout "$REMOTE_BRANCH"
git pull
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git branch -D "$BRANCH"
git checkout -b "$BRANCH"

cd ..
