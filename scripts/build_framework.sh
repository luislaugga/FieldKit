#!/bin/sh

# Exit the script if any statement returns a non-true return value
set -e 

# Don't Exit the script if it try to use an uninitialised variable
set +u

# Avoid recursively calling the script 
if [[ $FRAMEWORK_BUILD_SCRIPT_RUNNING ]]
then
exit 0
fi

# Exit the script if it try to use an uninitialised variable
set -u

# Mark build script as running (used to avoid recursively calling it)
export FRAMEWORK_BUILD_SCRIPT_RUNNING=1

# Sets the target folders and the final framework product
FRAMEWORK_TARGET_NAME=${PROJECT_NAME}
FRAMEWORK_EXECUTABLE_PATH="lib${FRAMEWORK_TARGET_NAME}.a"
FRAMEWORK_WRAPPER_NAME="${FRAMEWORK_TARGET_NAME}.framework"

# Check SDK platform
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
FRAMEWORK_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

# Check SDK version
if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
then
FRAMEWORK_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi

# Check other SDK platform
if [[ "$FRAMEWORK_SDK_PLATFORM" = "iphoneos" ]]
then
FRAMEWORK_OTHER_PLATFORM=iphonesimulator
else
FRAMEWORK_OTHER_PLATFORM=iphoneos
fi

# Check build directory
if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$FRAMEWORK_SDK_PLATFORM$ ]]
then
FRAMEWORK_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${FRAMEWORK_OTHER_PLATFORM}"
else
echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
exit 1
fi

# Target will build dependencies for one of the selected platforms (iphoneos or iphonesimulator)
# Build the other unselected platform in order to have builds for both platforms (will merge then into a fat library)
xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk ${FRAMEWORK_OTHER_PLATFORM}${FRAMEWORK_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

# Merge the two static libraries into one fat binary
lipo -create "${BUILT_PRODUCTS_DIR}/${FRAMEWORK_EXECUTABLE_PATH}" "${FRAMEWORK_OTHER_BUILT_PRODUCTS_DIR}/${FRAMEWORK_EXECUTABLE_PATH}" -output "${BUILT_PRODUCTS_DIR}/${FRAMEWORK_WRAPPER_NAME}/Versions/A/${FRAMEWORK_TARGET_NAME}"

# Copy the binary to the other architecture folder to have a complete framework in both (iphoneos and iphonesimulator)
cp -a "${BUILT_PRODUCTS_DIR}/${FRAMEWORK_WRAPPER_NAME}/Versions/A/${FRAMEWORK_TARGET_NAME}" "${FRAMEWORK_OTHER_BUILT_PRODUCTS_DIR}/${FRAMEWORK_WRAPPER_NAME}/Versions/A/${FRAMEWORK_TARGET_NAME}"

