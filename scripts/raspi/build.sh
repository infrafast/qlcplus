#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

if [[ ! -f "${BUILD_DIR}/CMakeCache.txt" ]]; then
  echo "Build directory is not configured; configuring first."
  "$(dirname "$0")/configure.sh"
fi

JOBS="${QLC_RPI_JOBS:-$(nproc)}"

echo "Building QLC+ 5 ARM64 with ${JOBS} jobs..."
cmake --build "${BUILD_DIR}" --parallel "${JOBS}"

echo
echo "Build complete."

BIN="${BUILD_DIR}/qmlui/qlcplus5"
if [[ -f "${BIN}" ]]; then
  echo
  file "${BIN}"
  if file "${BIN}" | grep -Eq 'ARM aarch64|ARM64|aarch64'; then
    echo "ARM64 executable verified: ${BIN}"
  else
    echo "WARNING: executable exists but 'file' did not identify it as ARM64."
  fi
else
  echo "WARNING: expected qlcplus5 binary not found at ${BIN}"
  echo "Upstream may have changed its output layout."
fi
