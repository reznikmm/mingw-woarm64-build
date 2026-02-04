#!/bin/bash
# Main build script for native aarch64-w64-mingw32 compiler (Canadian Cross)

source `dirname ${BASH_SOURCE[0]}`/config-native.sh

# We don't need to install dependencies or libraries again if cross-compiler is ready
# Just update sources if requested
if [[ "$UPDATE_SOURCES" = 1 ]]; then
    $ROOT_PATH/.github/scripts/update-sources.sh
fi

find "$SOURCE_PATH" -name setenv.c -exec sed -i -e "/= __environ = /s/__environ = //" {} \; -print

# Build binutils for HOST=aarch64-w64-mingw32
$ROOT_PATH/.github/scripts/toolchain-native/build-binutils.sh

# Build MinGW headers for HOST=aarch64-w64-mingw32
$ROOT_PATH/.github/scripts/toolchain-native/build-mingw-headers.sh

# Build GCC for HOST=aarch64-w64-mingw32
$ROOT_PATH/.github/scripts/toolchain-native/build-gcc.sh

# Copy mingw-w64 runtime from cross-compiler
$ROOT_PATH/.github/scripts/toolchain-native/copy-runtime.sh

echo 'Native toolchain build complete!'
