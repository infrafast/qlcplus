#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${QLC_RPI_BUILD_DIR:-${REPO_ROOT}/build-rpi-arm64}"
STAGE_DIR="${QLC_RPI_STAGE_DIR:-${REPO_ROOT}/out/rpi-arm64-rootfs}"
TOOLCHAIN="${REPO_ROOT}/cmake/toolchains/raspberry-pi-arm64.cmake"
REQUIRED_MERGE="4d439bea9"

export PKG_CONFIG_PATH=""
export PKG_CONFIG_LIBDIR="/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="/"

# Help CMake find target Qt6 package configs before any host Qt installation.
export CMAKE_PREFIX_PATH="/usr/lib/aarch64-linux-gnu/cmake${CMAKE_PREFIX_PATH:+:${CMAKE_PREFIX_PATH}}"

mkdir -p "${REPO_ROOT}/out"
