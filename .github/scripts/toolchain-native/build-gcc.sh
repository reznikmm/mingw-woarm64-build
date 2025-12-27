#!/bin/bash
# Build GCC for native aarch64-w64-mingw32 (Canadian Cross)

source `dirname ${BASH_SOURCE[0]}`/../config-native.sh

GCC_BUILD_PATH=$BUILD_PATH/gcc

mkdir -p $GCC_BUILD_PATH
cd $GCC_BUILD_PATH

if [[ "$RUN_CONFIG" = 1 ]] || [[ ! -f "$GCC_BUILD_PATH/Makefile" ]]; then
    echo "::group::Configure GCC for native build"
        rm -rf $GCC_BUILD_PATH/*

        # Target-specific options
        TARGET_OPTIONS="$TARGET_OPTIONS \
            --with-arch=armv8-a \
            --with-tune=cortex-a53"

        # MinGW-specific options
        TARGET_OPTIONS="$TARGET_OPTIONS \
            --libexecdir=$TOOLCHAIN_PATH/lib \
            --enable-shared \
            --enable-threads=win32 \
            --enable-graphite \
            --enable-fully-dynamic-string \
            --enable-libstdcxx-filesystem-ts \
            --enable-libstdcxx-time \
            --enable-cloog-backend=isl \
            --enable-version-specific-runtime-libs \
            --enable-lto \
            --enable-libgomp \
            --enable-checking=release \
            --disable-libstdcxx-pch \
            --disable-libstdcxx-debug \
            --disable-isl-version-check \
            --disable-libssp \
            --disable-rpath \
            --disable-win32-registry \
            --disable-werror \
            --disable-symvers \
            --with-libiconv"

        # Build GCC with Ada support
        # Note: We need a working cross-compiler Ada to build native Ada
        # The cross-compiler should already be in PATH from config-native.sh
        $SOURCE_PATH/gcc/configure \
            --prefix=$TOOLCHAIN_PATH \
            --build=$BUILD \
            --host=$HOST \
            --target=$TARGET \
            --enable-static \
            --enable-languages=ada,c,c++ \
            --disable-bootstrap \
            --disable-multilib \
            --with-gnu-as \
            --with-gnu-ld \
            --with-native-system-header-dir=/include \
            --with-build-time-tools=$CROSS_TOOLCHAIN_PATH/bin \
            $TARGET_OPTIONS
    echo "::endgroup::"
fi

echo "::group::Build GCC"
    make $BUILD_MAKE_OPTIONS
echo "::endgroup::"

if [[ "$RUN_INSTALL" = 1 ]]; then
    echo "::group::Install GCC"
        make install
        if [[ "$DELETE_BUILD" = 1 ]]; then
            rm -rf $GCC_BUILD_PATH
        fi
    echo "::endgroup::"
fi

echo 'GCC build success!'
