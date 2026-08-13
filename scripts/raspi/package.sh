#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

if [[ ! -f "${BUILD_DIR}/CMakeCache.txt" ]]; then
  echo "Nothing configured yet."
  exit 1
fi

rm -rf "${STAGE_DIR}"
mkdir -p "${STAGE_DIR}"

echo "Staging install tree into:"
echo "  ${STAGE_DIR}"
echo
echo "No files are installed into the Codespace host OS."

# QLC+'s install layout is rooted through INSTALL_ROOT. DESTDIR adds a safe staging root.
DESTDIR="${STAGE_DIR}" cmake --install "${BUILD_DIR}" --prefix /usr/local

STAMP="$(date -u +%Y%m%d-%H%M%S)"
ARCHIVE="${REPO_ROOT}/out/qlcplus5-rpi-arm64-${STAMP}.tar.gz"

tar -C "${STAGE_DIR}" -czf "${ARCHIVE}" .

echo
echo "Package created:"
echo "  ${ARCHIVE}"
echo
echo "Copy it to the Raspberry Pi, then inspect/extract it there."
