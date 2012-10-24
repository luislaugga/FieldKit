#!/bin/bash

# Exit the script if any statement returns a non-true return value
set -e

# Copy the current git long (<tag>-<sequence>-<commit>) and tag (<tag>) versions
CURRENT_GIT_LONG_VERSION=`git describe --tags --long`
CURRENT_GIT_TAG_VERSION=`git describe --abbrev=0 --tags`

# Update the value of CFBundleVersion and CFBundleShortVersionString in ${PRODUCT_NAME}-Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleVersion $CURRENT_GIT_LONG_VERSION (${CONFIGURATION})" "${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c "Set CFBundleShortVersionString $CURRENT_GIT_TAG_VERSION" "${INFOPLIST_FILE}"
