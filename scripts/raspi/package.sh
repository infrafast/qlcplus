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

BIN="${STAGE_DIR}/opt/qlcplus5-dev/usr/bin/qlcplus5dev"
if [[ ! -f "${BIN}" ]]; then
  echo "ERROR: staged ARM64 binary not found: ${BIN}"
  exit 1
fi

SOURCE_SHA="$(git -C "${REPO_ROOT}" rev-parse HEAD)"
cat > "${STAGE_DIR}/opt/qlcplus5-dev/BUILD-INFO.txt" <<EOF
QLC+ upstream master Linux ARM64 development build
Source commit: ${SOURCE_SHA}
Required merged PR: #2094 (${REQUIRED_MERGE})
Target: Raspberry Pi 5 / Linux ARM64
Install root: /opt/qlcplus5-dev
Native server options: -s/--server and -sa/--server-allow-all
EOF

STAMP="$(date -u +%Y%m%d-%H%M%S)"
ARCHIVE="${REPO_ROOT}/out/qlcplus5dev-rpi-arm64-${STAMP}.tar.gz"

tar -C "${STAGE_DIR}" -czf "${ARCHIVE}" .

tar -tzf "${ARCHIVE}" | grep -Fq './opt/qlcplus5-dev/usr/bin/qlcplus5dev'
file "${BIN}" | grep -Eq 'ARM aarch64|ARM64|aarch64'
sha256sum "${ARCHIVE}" > "${ARCHIVE}.sha256"

echo
echo "Package created:"
echo "  ${ARCHIVE}"
echo "  ${ARCHIVE}.sha256"
echo
echo "Copy it to the Raspberry Pi, then inspect/extract it there."
