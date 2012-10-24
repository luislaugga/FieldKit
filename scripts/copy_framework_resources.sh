#!/bin/bash

# Exit the script if any statement returns a non-true return value
set -e

# Directory for resources
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/Resources"

# Link the "Current" version to "A"
/bin/ln -sfh Versions/Current/Resources "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Resources"

# The -a ensures that the headers maintain the source modification date so that we don't constantly
# cause propagating rebuilds of files that import these headers.
/bin/cp -a "${TARGET_BUILD_DIR}/${PRODUCT_NAME}.bundle/" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/Resources"