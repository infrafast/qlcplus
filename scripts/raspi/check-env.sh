#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

echo "Checking QLC+ Raspberry Pi ARM64 cross-build environment..."

fail=0
for cmd in cmake ninja aarch64-linux-gnu-gcc aarch64-linux-gnu-g++ pkg-config file; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: missing command: $cmd"
    fail=1
  fi
done

if [[ ! -d /usr/lib/aarch64-linux-gnu/cmake/Qt6 ]]; then
  echo "ERROR: target Qt6 ARM64 CMake files not found."
  fail=1
fi

if [[ ! -f "${REPO_ROOT}/CMakeLists.txt" ]]; then
  echo "ERROR: CMakeLists.txt not found at repository root."
  echo "Unzip this kit at the root of your QLC+ fork."
  fail=1
fi

if grep -q 'option(qmlui "Build for QLC+ 5 QML UI"' "${REPO_ROOT}/CMakeLists.txt"; then
  echo "QLC+ CMake project detected."
else
  echo "WARNING: qmlui option not detected. Upstream build files may have changed."
fi

echo "Host : $(dpkg --print-architecture)"
echo "Target: arm64"
echo "Qt6 ARM64 config: /usr/lib/aarch64-linux-gnu/cmake/Qt6"
echo "Toolchain: ${TOOLCHAIN}"

if [[ $fail -ne 0 ]]; then
  exit 1
fi

echo "Environment looks ready."
