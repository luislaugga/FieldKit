#!/bin/bash

# Header file containing all artwork
FRAMEWORK_PNG_HEADER="${DERIVED_FILES_DIR}/FieldKit_png.h"

# Clean up previous build
rm -f "${FRAMEWORK_PNG_HEADER}"
mkdir -p "${DERIVED_FILES_DIR}"

# Copy artwork
cd "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/Resources/${PRODUCT_NAME}.bundle"
for png in *; do
    echo "xxd -i $png into ${FRAMEWORK_PNG_HEADER}"
	xxd -i "$png" >> "${FRAMEWORK_PNG_HEADER}"
done

# The -a ensures that the headers maintain the source modification date so that we don't constantly
# cause propagating rebuilds of files that import these headers.
/bin/cp -a "${FRAMEWORK_PNG_HEADER}" "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework/Versions/A/PrivateHeaders"