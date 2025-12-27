#!/bin/bash
# This script builds a native aarch64-w64-mingw32 compiler that runs on
# Windows ARM64 and targets Windows ARM64 (Canadian Cross).
#
# Prerequisites:
# 1. First build the cross-compiler with ./build.sh
# 2. Make sure cross-compiler is in PATH or set CROSS_TOOLCHAIN_PATH

set -e # exit on error
set -x # echo on

# Path to the cross-compiler (built with ./build.sh)
export CROSS_TOOLCHAIN_PATH=${CROSS_TOOLCHAIN_PATH:-~/cross-aarch64-w64-mingw32-msvcrt}

# Native compiler will run on Windows ARM64 and target Windows ARM64
export HOST=aarch64-w64-mingw32
export TARGET=aarch64-w64-mingw32

# Installation path for the native compiler
export TOOLCHAIN_PATH=${TOOLCHAIN_PATH:-~/native-aarch64-w64-mingw32-msvcrt}

# Use the cross-compiler we built earlier
export PATH=$CROSS_TOOLCHAIN_PATH/bin:$PATH

# Other configuration
export BINUTILS_REPO=${BINUTILS_REPO:-https://github.com/Windows-on-ARM-Experiments/binutils-woarm64.git}
export BINUTILS_BRANCH=${BINUTILS_BRANCH:-woarm64}

export GCC_REPO=${GCC_REPO:-https://github.com/Windows-on-ARM-Experiments/gcc-woarm64.git}
export GCC_BRANCH=${GCC_BRANCH:-woarm64}

export MINGW_REPO=${MINGW_REPO:-https://github.com/Windows-on-ARM-Experiments/mingw-woarm64.git}
export MINGW_BRANCH=${MINGW_BRANCH:-woarm64}

export RUN_BOOTSTRAP=${RUN_BOOTSTRAP:-0}
export UPDATE_SOURCES=${UPDATE_SOURCES:-0}

.github/scripts/build-native.sh

echo 'Native compiler build success!'
