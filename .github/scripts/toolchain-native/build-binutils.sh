#!/bin/bash
# Build binutils for native aarch64-w64-mingw32

source `dirname ${BASH_SOURCE[0]}`/../config-native.sh

BINUTILS_BUILD_PATH=$BUILD_PATH/binutils

mkdir -p $BINUTILS_BUILD_PATH
cd $BINUTILS_BUILD_PATH

# Disable strict function declaration checks for old K&R style declarations
# Add MinGW headers path for cross-compilation
export CFLAGS="$CFLAGS -Wno-error=incompatible-pointer-types -Wno-error=builtin-declaration-mismatch -Wno-error=implicit-function-declaration -Wno-error"

if [[ "$RUN_CONFIG" = 1 ]] || [[ ! -f "$BINUTILS_BUILD_PATH/Makefile" ]]; then
    echo "::group::Configure binutils for native build"
        rm -rf $BINUTILS_BUILD_PATH/*

        # Configuration for Canadian Cross:
        # We're building ON Linux (BUILD), FOR Windows ARM64 (HOST), TARGETING Windows ARM64 (TARGET)
        TARGET_OPTIONS="$TARGET_OPTIONS \
            --enable-lto \
            --enable-64-bit-bfd \
            --disable-werror \
            --disable-gdb \
            --disable-gdbserver \
            --disable-libdecnumber \
            --disable-sim"

        $SOURCE_PATH/binutils/configure \
            --prefix=$TOOLCHAIN_PATH \
            --build=$BUILD \
            --host=$HOST \
            --target=$TARGET \
            $TARGET_OPTIONS
    echo "::endgroup::"
fi

echo "::group::Build binutils"
    make $BUILD_MAKE_OPTIONS
echo "::endgroup::"

if [[ "$RUN_INSTALL" = 1 ]]; then
    echo "::group::Install binutils"
        make install
        if [[ "$DELETE_BUILD" = 1 ]]; then
            rm -rf $BINUTILS_BUILD_PATH
        fi
    echo "::endgroup::"
fi

echo 'Binutils build success!'
