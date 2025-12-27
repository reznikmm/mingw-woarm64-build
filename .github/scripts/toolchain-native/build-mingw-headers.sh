#!/bin/bash
# Build MinGW headers for native aarch64-w64-mingw32

source `dirname ${BASH_SOURCE[0]}`/../config-native.sh

MINGW_HEADERS_BUILD_PATH=$BUILD_PATH/mingw-headers

mkdir -p $MINGW_HEADERS_BUILD_PATH
cd $MINGW_HEADERS_BUILD_PATH

if [[ "$RUN_CONFIG" = 1 ]] || [[ ! -f "$MINGW_HEADERS_BUILD_PATH/Makefile" ]]; then
    echo "::group::Configure MinGW headers for native build"
        rm -rf $MINGW_HEADERS_BUILD_PATH/*

        if [[ "$DEBUG" = 1 ]]; then
            HOST_OPTIONS="$HOST_OPTIONS \
                --enable-debug"
        fi

        case "$PLATFORM-$CRT" in
            *mingw*-ucrt)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --with-default-win32-winnt=0x603 \
                    --with-default-msvcrt=ucrt"
            ;;
            *mingw*-msvcrt)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --with-default-win32-winnt=0x601 \
                    --with-default-msvcrt=msvcrt"
            ;;
        esac

        # For Canadian Cross, we configure headers with:
        # --build = Linux (where we're compiling)
        # --host = Windows ARM64 (where headers will be used)
        $SOURCE_PATH/mingw/mingw-w64-headers/configure \
            --prefix=$TOOLCHAIN_PATH/$TARGET \
            --build=$BUILD \
            --host=$HOST \
            --enable-sdk=all \
            $HOST_OPTIONS \
            $TARGET_OPTIONS
    echo "::endgroup::"
fi

echo "::group::Build MinGW headers"
    make $BUILD_MAKE_OPTIONS
echo "::endgroup::"

if [[ "$RUN_INSTALL" = 1 ]]; then
    echo "::group::Install MinGW headers"
        make install

        # Symlink for gcc
        ln -sf $TOOLCHAIN_PATH/$TARGET $TOOLCHAIN_PATH/mingw

        if [[ "$DELETE_BUILD" = 1 ]]; then
            rm -rf $MINGW_HEADERS_BUILD_PATH
        fi
    echo "::endgroup::"
fi

echo 'MinGW headers build success!'
