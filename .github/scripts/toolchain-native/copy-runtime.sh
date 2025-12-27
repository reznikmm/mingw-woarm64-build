#!/bin/bash
# Copy mingw-w64 runtime libraries from cross-compiler to native compiler

source `dirname ${BASH_SOURCE[0]}`/../config-native.sh

echo "::group::Copy mingw-w64 runtime"

# Create target directories
mkdir -p $TOOLCHAIN_PATH/$TARGET
mkdir -p $TOOLCHAIN_PATH/lib

# Copy mingw-w64 headers and libraries from cross-compiler
if [ -d "$CROSS_TOOLCHAIN_PATH/$TARGET/include" ]; then
    cp -r $CROSS_TOOLCHAIN_PATH/$TARGET/include $TOOLCHAIN_PATH/$TARGET/
    echo "Copied headers from cross-compiler"
fi

if [ -d "$CROSS_TOOLCHAIN_PATH/$TARGET/lib" ]; then
    cp -r $CROSS_TOOLCHAIN_PATH/$TARGET/lib $TOOLCHAIN_PATH/$TARGET/
    echo "Copied libraries from cross-compiler"
fi

# Copy mingw-w64 runtime DLLs (they will be needed on Windows)
if [ -d "$CROSS_TOOLCHAIN_PATH/bin" ]; then
    mkdir -p $TOOLCHAIN_PATH/bin
    # Copy only DLLs that are part of mingw-w64 runtime
    for dll in libgcc_s_seh-1.dll libstdc++-6.dll libwinpthread-1.dll libgomp-1.dll libgnat-*.dll libgnarl-*.dll; do
        if [ -f "$CROSS_TOOLCHAIN_PATH/bin/$dll" ]; then
            cp $CROSS_TOOLCHAIN_PATH/bin/$dll $TOOLCHAIN_PATH/bin/ 2>/dev/null || true
        fi
    done
    echo "Copied runtime DLLs"
fi

echo "::endgroup::"

echo 'Runtime copy success!'
