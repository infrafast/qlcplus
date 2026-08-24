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
    echo "ERROR: executable exists but 'file' did not identify it as ARM64."
    exit 1
  fi
else
  echo "ERROR: expected qlcplus5 binary not found at ${BIN}"
  exit 1
fi

if ! strings "${BIN}" | grep -F 'server-allow-all' >/dev/null; then
  echo "ERROR: compiled binary does not contain --server-allow-all."
  exit 1
fi

if ! strings "${BIN}" | grep -F 'Automatically grant full access to every native TCP client' >/dev/null; then
  echo "ERROR: compiled binary does not contain the -sa/--server-allow-all help text."
  exit 1
fi

echo "Compiled -sa/--server-allow-all option verified."
