#!/bin/bash

# Get the current version from package.json
VERSION=$(grep -oP '"version":\s*"\K[0-9.]+' package.json)

# Split version into an array
IFS='.' read -r -a VERSION_PARTS <<< "$VERSION"

# Increment the patch version
NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.$((VERSION_PARTS[2] + 1))"

# Replace the version in package.json
sed -i "s/\"version\": \"$VERSION\"/\"version\": \"$NEW_VERSION\"/" package.json

# Regenerate package-lock.json with the new version
npm install --package-lock-only

echo "Version bumped to $NEW_VERSION"
