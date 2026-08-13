#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

"${HERE}/configure.sh"
"${HERE}/build.sh"
"${HERE}/package.sh"
