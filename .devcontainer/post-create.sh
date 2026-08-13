#!/usr/bin/env bash
set -euo pipefail

echo
echo "============================================================"
echo " QLC+ 5 Raspberry Pi ARM64 cross-build environment"
echo "============================================================"
echo "Host architecture : $(dpkg --print-architecture)"
echo "Target architecture: arm64 / aarch64-linux-gnu"
echo "Cross compiler     : $(command -v aarch64-linux-gnu-g++)"
echo
echo "Next commands:"
echo "  ./scripts/raspi/configure.sh"
echo "  ./scripts/raspi/build.sh"
echo "  ./scripts/raspi/package.sh"
echo
echo "Or use:  ./scripts/raspi/all.sh"
echo "============================================================"
echo

chmod +x scripts/raspi/*.sh 2>/dev/null || true
