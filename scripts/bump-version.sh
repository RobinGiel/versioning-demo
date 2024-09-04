#!/bin/bash

# Ensure the script is running on the master branch
BRANCH=$(git branch --show-current)

if ! [[ ${BRANCH} =~ ^master ]]; then
  echo "Script can only be executed on the master branch."
  exit 1
fi

# Get the current version from package.json
VERSION=$(grep -oP '"version":\s*"\K[0-9.]+' package.json)

# Split version into an array
IFS='.' read -r -a VERSION_PARTS <<< "$VERSION"

# Increment the patch version
NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.$((VERSION_PARTS[2] + 1))"

# Replace the version in package.json
sed -i "s/\"version\": \"$VERSION\"/\"version\": \"$NEW_VERSION\"/" package.json

# Replace the version in package-lock.json
sed -i "s/\"version\": \"$VERSION\"/\"version\": \"$NEW_VERSION\"/" package-lock.json

# Print the new version
echo "Bumped version to $NEW_VERSION"

# Set the new version as an output variable
echo "::set-output name=new_version::$NEW_VERSION"
