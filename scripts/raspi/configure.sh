#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

"$(dirname "$0")/check-env.sh"

BUILD_TYPE="${QLC_RPI_BUILD_TYPE:-Release}"

echo
echo "Configuring QLC+ 5 for Raspberry Pi ARM64..."
echo "Build type: ${BUILD_TYPE}"
echo "Build dir : ${BUILD_DIR}"

cmake \
  -S "${REPO_ROOT}" \
  -B "${BUILD_DIR}" \
  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN}" \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -Dqmlui=ON \
  -DQT_HOST_PATH=/usr \
  -DQT_DIR=/usr/lib/aarch64-linux-gnu/cmake/Qt6 \
  -DCMAKE_PREFIX_PATH=/usr/lib/aarch64-linux-gnu/cmake

echo
echo "Configuration complete."
