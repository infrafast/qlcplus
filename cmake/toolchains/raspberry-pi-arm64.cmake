# Cross compilation toolchain for 64-bit Raspberry Pi OS / Debian ARM64.
#
# The Codespace is amd64. Target libraries are Debian arm64 multiarch packages
# installed under /usr/lib/aarch64-linux-gnu and /usr/include.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER   /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# Debian multiarch target tuple.
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-linux-gnu)

# Avoid accidentally executing target binaries while configuring.
set(CMAKE_CROSSCOMPILING_EMULATOR "")

# Prefer target headers/libraries/packages, but host programs (moc, lrelease, etc.)
# must still be found on the amd64 Codespace.
set(CMAKE_FIND_ROOT_PATH
    /usr/aarch64-linux-gnu
)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)

# Qt's host-side tools are provided by the native Debian qt6 *-dev-tools packages.
set(QT_HOST_PATH "/usr" CACHE PATH "Host Qt installation")

# pkg-config is controlled by configure.sh to expose only ARM64 target metadata.
