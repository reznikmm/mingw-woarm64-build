#!/bin/bash
# Configuration for building native aarch64-w64-mingw32 compiler

set -e # exit on error
set -x # echo on
set -o pipefail # fail of any command in pipeline is an error

# Source repository configuration
BINUTILS_REPO=${BINUTILS_REPO:-Windows-on-ARM-Experiments/binutils-woarm64}
BINUTILS_BRANCH=${BINUTILS_BRANCH:-woarm64}

GCC_REPO=${GCC_REPO:-Windows-on-ARM-Experiments/gcc-woarm64}
GCC_BRANCH=${GCC_BRANCH:-woarm64}

MINGW_REPO=${MINGW_REPO:-Windows-on-ARM-Experiments/mingw-woarm64}
MINGW_BRANCH=${MINGW_BRANCH:-woarm64}

# Target architecture and platform
ARCH=${ARCH:-aarch64}
PLATFORM=${PLATFORM:-w64-mingw32}
CRT=${CRT:-msvcrt}

# Build triplets for Canadian Cross
# BUILD = where we compile (Linux)
# HOST = where the compiler will run (Windows ARM64)
# TARGET = what the compiler produces (Windows ARM64)
PROCESSOR=$(uname --machine)
BUILD=${BUILD:-$PROCESSOR-pc-linux-gnu}
HOST=${HOST:-aarch64-w64-mingw32}
TARGET=${TARGET:-aarch64-w64-mingw32}
TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-native-$ARCH-$PLATFORM-$CRT}

# Paths
ROOT_PATH=${ROOT_PATH:-$(realpath $(dirname ${BASH_SOURCE[0]})/../..)}
SOURCE_PATH=${SOURCE_PATH:-$ROOT_PATH/code}
DOWNLOADS_PATH=${DOWNLOADS_PATH:-$ROOT_PATH/downloads}
PATCHES_PATH=${PATCHES_PATH:-$ROOT_PATH/patches}
BUILD_PATH=${BUILD_PATH:-$ROOT_PATH/build-$TOOLCHAIN_NAME}
ARTIFACT_PATH=${ARTIFACT_PATH:-$ROOT_PATH/artifact}
BUILD_MAKE_OPTIONS=${BUILD_MAKE_OPTIONS:-V=1 -j$(nproc)}
TOOLCHAIN_PATH=${TOOLCHAIN_PATH:-~/native-$ARCH-$PLATFORM-$CRT}
TOOLCHAIN_PACKAGE_NAME=${TOOLCHAIN_PACKAGE_NAME:-$TOOLCHAIN_NAME-toolchain.tar.gz}

# Path to cross-compiler (needed to build native compiler)
CROSS_TOOLCHAIN_PATH=${CROSS_TOOLCHAIN_PATH:-~/cross-$ARCH-$PLATFORM-$CRT}

RUN_INSTALL=${RUN_INSTALL:-1} # Run installation step.

# Make sure cross-compiler is in PATH
export PATH=$CROSS_TOOLCHAIN_PATH/bin:$PATH

# Compiler to use for building (cross-compiler)
export CC=$HOST-gcc
export CXX=$HOST-g++
export AR=$HOST-ar
export RANLIB=$HOST-ranlib
export DLLTOOL=$HOST-dlltool
export WINDRES=$HOST-windres

echo "Building native compiler:"
echo "  BUILD:  $BUILD (where we compile)"
echo "  HOST:   $HOST (where compiler runs)"
echo "  TARGET: $TARGET (what compiler produces)"
echo "  Using cross-compiler from: $CROSS_TOOLCHAIN_PATH"
echo "  Installing to: $TOOLCHAIN_PATH"
