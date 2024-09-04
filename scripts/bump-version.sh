#!/bin/bash

# Ensure the script is running on the master branch
BRANCH=$(git branch --show-current)

if ! [[ ${BRANCH} =~ ^master ]]; then
  echo "Script can only be executed on the master branch."
  exit 1
fi

# Ensure a valid version bump type is provided
USAGE="Usage: scripts/bump-version.sh [major | minor | patch]"

if [ "$1" != "major" ] && [ "$1" != "minor" ] && [ "$1" != "patch" ]; then
  echo "Version is invalid."
  echo $USAGE
  exit 1
fi

# Bump the version in package.json and package-lock.json
NEW_VERSION=$(npm version $1 --no-git-tag-version | sed -n 2p | cut -c2-)

if [ -z $NEW_VERSION ]; then
  echo "Version bump failed."
  exit 1
fi

# Commit the changes and create a git tag
git add "./*package.json" package-lock.json
git commit -m "build: bump version to $NEW_VERSION [skip ci]"
git tag "$NEW_VERSION"
git push
git push --tags
