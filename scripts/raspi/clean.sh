#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

rm -rf "${BUILD_DIR}" "${STAGE_DIR}"
echo "Removed:"
echo "  ${BUILD_DIR}"
echo "  ${STAGE_DIR}"
